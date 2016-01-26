#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);    
    connect(&cpuObj,SIGNAL(signalSendCpuInfo(QString)),ui->textBrowser,SLOT(append(QString)));
}

MainWindow::~MainWindow()
{
    delete ui;
}
