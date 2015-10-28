import QtQuick 2.4
import "../common"

/*!
  \qmltype GameTimer
  \inherits Item
  \brief A graphic object on the game scene which shows time for the current level.
*/

Item {
    id: gameTimer

    /*!
      \qmlproperty int GameTimer::gameMillisecondsTotal
      \brief The total amount of milliseconds which the timer has to count down.
     */
    property int gameMillisecondsTotal: 30000

    /*!
      \qmlproperty int GameTimer::gameMillisecondsCurrent
      \brief The current amount of milliseconds which are left to count down.
     */
    property int gameMillisecondsCurrent: gameMillisecondsTotal

    width: 90
    height: 30

    /*!
      \qmlmethod void GameTimer::stop()
      It stops the game timer.
     */
    function stop() {
        timer.stop()
    }

    /*!
      \qmlmethod void GameTimer::start()
      It starts the game timer.
     */
    function start() {
        gameMillisecondsCurrent = gameMillisecondsTotal
        timer.start()
    }

    /*!
      \qmlmethod void GameTimer::pause()
      It pauses the game timer.
     */
    function pause( isPaused ) {
        if( isPaused ) {
            timer.stop()
        } else {
            timer.start()
        }
    }

    /*!
      \qmlsignal void GameTimer::timerIsOver()
      It is emitted when the countdown is finished. It means when \a gameMillisecondsCurrent is zero.
     */
    signal timerIsOver()

    Image {
        id: img
        source: "../../assets/img/bar_clock.png"
        width: parent.width
        height: parent.height

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2
            anchors.left: parent.left
            anchors.leftMargin: gameTimer.width*0.26
            width: gameMillisecondsTotal != 0 ? (gameTimer.width - gameTimer.width*0.34)*(gameMillisecondsCurrent/gameMillisecondsTotal) : (gameTimer.width - gameTimer.width*0.34)
            Behavior on width { NumberAnimation { duration: 400 } }
            height: gameTimer.height*0.4
            gradient: Gradient {
                GradientStop { position: 0; color: "#71c8fe" }
                GradientStop { position: 1; color: "#70adfd" }
            }
        }

        Label {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 8
            anchors.verticalCenterOffset: -1
            font.pixelSize: parent.height*0.4
            text: formatTime( gameMillisecondsCurrent )
        }
    }

    Timer {
        id: timer
        interval: 100
        triggeredOnStart: false
        repeat: true
        onTriggered: {
            gameMillisecondsCurrent = gameMillisecondsCurrent - interval
            if( gameMillisecondsCurrent == 0 ) {
                gameTimer.stop()
                gameTimer.timerIsOver()
            }
        }
    }


    /*!
      \qmlmethod string GameTimer::formatTime( milliseconds )
      It converts \a milliseconds to a formatted string of time. It looks like MM:SS.MS
     */
    function formatTime( milliseconds ) {

        /*
          qmlmethod string GameTimer::addZ( n )
         */
        //function addZ(n) { return (n<10? '0':'') + n; }

        var ms = s % 1000;
        s = (s - ms) / 1000;
        var secs = s % 60;
        s = (s - secs) / 60;
        var mins = s % 60;

        //return addZ(mins) + ':' + addZ(secs) + '.' + (ms / 100);
        return (mins<10 ? '0'+mins : mins) + ':' + (secs<10 ? '0'+secs : secs) + '.' + (ms / 100);
    }
}

