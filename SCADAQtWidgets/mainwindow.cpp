#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    slmpThread = new SLMPThread(this);
    connect(slmpThread, &SLMPThread::newBatchReading, this, &MainWindow::onBatchReading);
    connect(slmpThread, &SLMPThread::newRandomReading, this, &MainWindow::onRandomReading);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_connectBtn_clicked()
{
    slmpThread->init();
}


void MainWindow::on_startBtn_clicked()
{
    slmpThread->start();
}

void MainWindow::onBatchReading(int val1, int val2, int val3)
{
}

void MainWindow::onRandomReading(int val1, int val2, int val3)
{
    ui->tag1Lbl->setText(QString::number(val1));
    ui->tag2Lbl->setText(QString::number(val2));
    ui->tag3Lbl->setText(QString::number(val3));
}

