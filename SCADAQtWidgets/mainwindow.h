#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "../slmpthread.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_connectBtn_clicked();

    void on_startBtn_clicked();

public slots:
    void onBatchReading(int val1, int val2, int val3);
    void onRandomReading(int val1, int val2, int val3);


private:
    Ui::MainWindow *ui;

    SLMPThread *slmpThread;
};
#endif // MAINWINDOW_H
