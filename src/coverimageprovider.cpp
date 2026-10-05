#include "coverimageprovider.h"
#include <QCache>
#include <QDebug>
#include <QFutureWatcher>
#include <QMutex>
#include <QMutexLocker>
#include <QQuickImageResponse>
#include <QQuickTextureFactory>
#include <QtConcurrent/QtConcurrentRun>

QCache<QString, QImage> imageCache(32 * 1024 * 1024);
QMutex imageCacheMutex;

static QImage loadCoverImage(const QString &id, const QSize &requestedSize)
{
	const QString cacheKey = id + QString::number(requestedSize.width())
		+ QLatin1Char('x') + QString::number(requestedSize.height());
	{
		QMutexLocker locker(&imageCacheMutex);
		if (const QImage *cached = imageCache.object(cacheKey))
			return *cached;
	}

	TagLib::FileRef file(id.toUtf8().constData());

	QString fileType = id.right(3).toUpper();
	QImage image;

	if (fileType.compare(QString("MP3")) == 0) {
		TagLib::MPEG::File audioFile(
			(QString("/") + id).toUtf8().constData());
		TagLib::ID3v2::Tag *tag = audioFile.ID3v2Tag(true);
		TagLib::ID3v2::FrameList l = tag->frameList("APIC");
		if (!l.isEmpty()) {
			TagLib::ID3v2::AttachedPictureFrame *f =
				static_cast<TagLib::ID3v2::AttachedPictureFrame *>(
					l.front());
			image.loadFromData((const uchar *)f->picture().data(),
					   f->picture().size());
		}
	} else if (fileType.compare(QString("OGG")) == 0) {
		TagLib::Ogg::Vorbis::File audioFile(
			(QString("/") + id).toUtf8().constData());
		TagLib::Ogg::XiphComment *tag = audioFile.tag();
		if (tag && !(tag->pictureList().isEmpty())) {
			TagLib::FLAC::Picture *pic = tag->pictureList()[0];
			image.loadFromData(
				(const unsigned char *)pic->data().data(),
				(int)pic->data().size());
		}
	}

	if (image.isNull()) {
		QImageReader reader(":/cutie-music.svg");
		reader.setScaledSize(requestedSize.isValid()
					      ? requestedSize
					      : QSize(512, 512));
		image = reader.read();
	}

	if (!image.isNull()) {
		QMutexLocker locker(&imageCacheMutex);
		imageCache.insert(cacheKey, new QImage(image),
				  qMax(1, (int)image.sizeInBytes()));
	}

	return image;
}

class CoverImageResponse : public QQuickImageResponse
{
public:
	CoverImageResponse(const QString &id, const QSize &requestedSize)
	{
		auto *watcher = new QFutureWatcher<QImage>(this);
		connect(watcher, &QFutureWatcher<QImage>::finished, this, [this, watcher] {
			m_image = watcher->result();
			emit finished();
			watcher->deleteLater();
		});
		watcher->setFuture(QtConcurrent::run(loadCoverImage, id, requestedSize));
	}

	QQuickTextureFactory *textureFactory() const override
	{
		return QQuickTextureFactory::textureFactoryForImage(m_image);
	}

	void cancel() override {}

private:
	QImage m_image;
};
CoverImageProvider::CoverImageProvider()
	: QQuickAsyncImageProvider()
{
}

QQuickImageResponse *CoverImageProvider::requestImageResponse(
	const QString &id, const QSize &requestedSize)
{
	qDebug().noquote() << "CoverImageProvider::requestImage:" << id
			   << "requestedSize:" << requestedSize;
	return new CoverImageResponse(id, requestedSize);
}
