#import "SnapshotHelper.js"

var target = UIATarget.localTarget();
var app = target.frontMostApp();
var window = app.mainWindow();

var target = UIATarget.localTarget();

target.frontMostApp().mainWindow().buttons()[0].tap();
captureLocalizedScreenshot("0-name")
target.frontMostApp().mainWindow().buttons()["GO BACK"].tap();
captureLocalizedScreenshot("0-name")
target.frontMostApp().mainWindow().images()[0].tapWithOptions({tapOffset:{x:0.48, y:0.50}});
target.delay(2)
captureLocalizedScreenshot("0-name")
target.frontMostApp().navigationBar().rightButton().tap();
captureLocalizedScreenshot("0-name")