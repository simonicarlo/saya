#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QDir>
#include <QFileInfo>
#include <QImage>
#include <QTimer>

namespace {

// Development capture. Inert unless SAYA_SHOT names an output file:
//
//   SAYA_SHOT=/tmp/shots/results.png SAYA_STATE=results SAYA_THEME=light ./appsaya
//
// The window renders itself to a PNG and quits. Unlike a screen grab this
// needs no screen-recording permission, does not steal focus, and captures
// exactly the window rather than whatever happens to be in front of it.
//
// Scaffolding, like DevStrip.qml -- both come out once the engine drives the UI.

int stateIndex(const QByteArray &name)
{
    if (name == "scanning") return 1;
    if (name == "results")  return 2;
    return 0;   // empty
}

int themeIndex(const QByteArray &name)
{
    if (name == "light") return 1;
    if (name == "dark")  return 2;
    return 0;   // follow the system
}

void setUpCapture(QQuickWindow *window)
{
    const QString path = QString::fromLocal8Bit(qgetenv("SAYA_SHOT"));
    if (path.isEmpty())
        return;

    // SAYA_SIZE=900x600 -- useful for checking how the layout compresses.
    const QByteArrayList size = qgetenv("SAYA_SIZE").split('x');
    if (size.size() == 2)
        window->resize(size.at(0).toInt(), size.at(1).toInt());

    window->setProperty("devState", stateIndex(qgetenv("SAYA_STATE")));
    window->setProperty("devTheme", themeIndex(qgetenv("SAYA_THEME")));

    // Long enough for the first frame, the theme switch and the view
    // cross-fade to settle. Raise it with SAYA_SHOT_DELAY to catch the scan
    // animation at a particular point.
    const int delay = qEnvironmentVariableIntValue("SAYA_SHOT_DELAY") > 0
                          ? qEnvironmentVariableIntValue("SAYA_SHOT_DELAY")
                          : 800;

    QTimer::singleShot(delay, window, [window, path] {
        QDir().mkpath(QFileInfo(path).absolutePath());
        const QImage frame = window->grabWindow();
        if (frame.save(path))
            qInfo("saved %s (%dx%d)", qPrintable(path), frame.width(), frame.height());
        else
            qWarning("could not save %s", qPrintable(path));
        QCoreApplication::quit();
    });
}

} // namespace

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("saya", "Main");

    if (!engine.rootObjects().isEmpty()) {
        if (auto *window = qobject_cast<QQuickWindow *>(engine.rootObjects().constFirst()))
            setUpCapture(window);
    }

    return QGuiApplication::exec();
}
