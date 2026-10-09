#include <fileref.h>
#include <tag.h>
#include <attachedpictureframe.h>
#include <id3v2frame.h>
#include <id3v2tag.h>
#include <xiphcomment.h>
#include <vorbisfile.h>
#include <mpegfile.h>
#include <QQuickAsyncImageProvider>
#include <QImage>
#include <QImageReader>

class CoverImageProvider : public QQuickAsyncImageProvider {
    public:
	CoverImageProvider();

	QQuickImageResponse *requestImageResponse(const QString &id,
						 const QSize &requestedSize) override;
};
