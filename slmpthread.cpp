#include "slmpthread.h"

SLMPThread::SLMPThread(QObject* parent) : QThread(parent), m_running(true), m_file("D:/readout.txt")
{
    if (!m_file.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text))
    {
        qWarning() << "Failed to open file for writing";
    }
    m_stream.setDevice(&m_file);
    m_stream.setRealNumberNotation(QTextStream::FixedNotation); // Optional: better formatting
    m_stream.setRealNumberPrecision(6);


    word_addrs_random[0] = "D110";
    word_addrs_random[1] = "D115";
    word_addrs_random[2] = "D120";
    word_addrs_random[3] = NULL;

    word_addrs_batch = "D12";
}

int SLMPThread::init()
{
    ctxtype = MELCLI_TYPE_TCPIP;

    strcpy_s(target_ip_addr, "192.168.3.250");
    target_port = 401;

    /* Create a connection context and store it into `g_ctx`. */
    g_ctx = melcli_new_context(ctxtype, target_ip_addr, target_port, local_ip_addr, local_port, &target_station, &timeout);
    if (g_ctx == NULL)
    {
        qDebug() << "Failed to create connection context.";
        return -1;
    }

    // /* Enable debug information printout. */
    //melcli_set_debug(g_ctx, 1);

    qDebug() << "Connecting to " << target_ip_addr << ":" << target_port;
    if (melcli_connect(g_ctx) != 0)
    {
        qDebug() << "Failed to connect.";
        return -1;
    }

    qDebug() << "Connected.";

    return 0;
}

void SLMPThread::stopReading()
{
    m_running.storeRelaxed(false);
}

void SLMPThread::listOfRandomAddress(const QVariantList &addressList)
{
    for (int i = 0; i < addressList.size(); i++)
    {
        m_byteArrayRandom[i] = addressList[i].toString().toUtf8();
        word_addrs_random[i] = m_byteArrayRandom[i].constData();
    }
}

void SLMPThread::listOfBatchAddress(const QVariantList &addressList)
{
    m_byteArrayBatch = addressList[0].toString().toUtf8();
    word_addrs_batch = m_byteArrayBatch.constData();
}

void SLMPThread::write_slmp()
{
    const char *word_addrs[] = { "M0", NULL };
    uint16_t *data = new uint16_t[1];

    qDebug() << "Writing M0";

    data[0] = 1;
    if (melcli_random_write_word(g_ctx, NULL, word_addrs, data) != 0)
    {
        qDebug() << "Failed.";
    }

    //melcli_free(data);
}

void SLMPThread::read_slmp()
{
    const char *word_addrs[] = { "D12", "D22", NULL };
    uint16_t *data = NULL;

    //qDebug() << "Reading D12, D22";
    if (melcli_random_read_word(g_ctx, NULL, word_addrs, &data, NULL) != 0)
    {
        //qDebug() << "Failed.";
    }
    else
    {
        //qDebug() << "D12=" << data[0] << ", D22=" << data[1];

        //emit this signal to anywhere (like to QML side)
        //emit newReading(data[0], data[1]);
        m_buffer.append(data[0]);
        if (m_buffer.size() >= 100000)
        {
            flushBufferToFile();
        }

        // c++;
        // if (!m_series1 && !m_series2)
        //     return;

        // m_series1->append(c, data[0]);    //c
        // m_series2->append(c, data[1]);    //c

        // if (m_series1->count() > 2000)
        // {
        //     m_series1->clear();
        // }

        // if (m_series2->count() > 2000)
        // {
        //     m_series2->clear();
        // }
    }


    //c++;
    // emit newReading(c, c);
    // m_buffer.append(c);
    // if (m_buffer.size() >= 100000)
    // {
    //     flushBufferToFile();
    // }
    //qDebug() << "Emit done. " << c;

    // if (!m_series1 && !m_series2)
    //     return;

    //m_series1->append(c, c);    //c
    //m_series2->append(c, 1000 - c);    //c

    // if (m_series1->count() > 2000)
    // {
    //     m_series1->clear();
    // }

    // if (m_series2->count() > 2000)
    // {
    //     m_series2->clear();
    // }

    melcli_free(data);
}

void SLMPThread::read_mix_slmp()
{
    numOfValues = 4;   // number of elements in word_addrs

    //qDebug() << word_addrs_random[0] << ", " << word_addrs_random[1] << ", " << word_addrs_random[2];

    //for simulation
    // c++;
    // uint16_t *data = new uint16_t[numOfValues];
    // for (int i = 0; i < numOfValues; i++)
    // {
    //     data[i] = c;
    // }


    uint16_t *data = NULL;

    int isError = melcli_random_read_word(g_ctx, NULL, word_addrs_random, &data, NULL);
    if (isError == 0)
    {
        emit newRandomReading(data[0], data[1], data[2]);

        // QVector<uint16_t> readDataVector(numOfValues, 0);
        // for (int i = 0; i < numOfValues; i++)
        // {
        //     readDataVector[i] = data[i];
        // }

        // m_bufferMultiValues.append(readDataVector);
        // if (m_bufferMultiValues.size() >= 100000)
        // {
        //     //flushBufferToFileMultiValue();
        //     flushBufferToFileMultiValueByteArray();
        // }

        melcli_free(data);
    }

    // delete[] data;
    // data = nullptr;
}

void SLMPThread::read_consecutive_slmp()
{
    numOfValues = 3;

    //qDebug() << word_addrs_batch;

    //for simulation
    // c++;
    // uint16_t *rd_words = new uint16_t[numOfValues];
    // for (int i = 0; i < numOfValues; i++)
    // {
    //     rd_words[i] = c * 2;
    // }

    uint16_t *rd_words;

    int isError = melcli_batch_read(g_ctx, NULL, word_addrs_batch, numOfValues, (char**)(&rd_words), NULL);   //D12 to D32 included
    if (isError == 0)
    {
        emit newBatchReading(rd_words[0], rd_words[1], rd_words[2]);

        // QVector<uint16_t> readDataVector(numOfValues, 0);
        // for (int i = 0; i < numOfValues; i++)
        // {
        //     readDataVector[i] = rd_words[i];
        // }

        // m_bufferMultiValues.append(readDataVector);
        // if (m_bufferMultiValues.size() >= 100000)
        // {
        //     //flushBufferToFileMultiValue();
        //     flushBufferToFileMultiValueByteArray();
        // }

        melcli_free(rd_words);
    }

    // delete[] rd_words;
    // rd_words = nullptr;
}

void SLMPThread::setSeries(QAbstractSeries *series1, QAbstractSeries *series2)
{
    m_series1 = qobject_cast<QLineSeries*>(series1);
    m_series2 = qobject_cast<QLineSeries*>(series2);
}

void SLMPThread::flushBufferToFile()
{
    // if (m_file.isOpen() && !m_buffer.isEmpty())
    // {
    //     m_file.write(reinterpret_cast<const char*>(m_buffer.constData()), m_buffer.size() * sizeof(double));
    //     m_buffer.clear();
    // }


    if (m_file.isOpen() && !m_buffer.isEmpty()) {
        for (double value : std::as_const(m_buffer)) {
            m_stream << value << "\n";
        }
        m_stream.flush();
        m_buffer.clear();
    }
}

void SLMPThread::flushBufferToFileMultiValue()
{
    if (m_file.isOpen() && !m_bufferMultiValues.isEmpty())
    {
        for (const QVector<uint16_t> &readDataVector : std::as_const(m_bufferMultiValues))
        {
            for (const uint16_t &value : std::as_const(readDataVector))
            {
                m_stream << value << "\t";
            }
            m_stream << "\n";
        }
        m_stream.flush();
        m_bufferMultiValues.clear();
        m_bufferMultiValues.reserve(100000); // Reserve space to reduce reallocations
    }
}

void SLMPThread::flushBufferToFileMultiValueByteArray()
{
    if (m_file.isOpen() && !m_bufferMultiValues.isEmpty())
    {
        QByteArray data;
        data.reserve(m_bufferMultiValues.size() * numOfValues * 7);

        for (const QVector<uint16_t> &readDataVector : std::as_const(m_bufferMultiValues))
        {
            for (const uint16_t &value : std::as_const(readDataVector))
            {
                data.append(QByteArray::number(value));
                data.append("\t");
            }
            data.append("\n");
        }
        m_file.write(data);
        m_bufferMultiValues.clear();
        m_bufferMultiValues.reserve(100000); // Reserve space to reduce reallocations
    }
}

void SLMPThread::run()
{
    //m_buffer.reserve(100000); // Reserve space to reduce reallocations
    //m_bufferMultiValues.reserve(100000); // Reserve space to reduce reallocations

    while (m_running.loadRelaxed())
    {
        //read_slmp();
        read_mix_slmp();
        read_consecutive_slmp();

        QThread::usleep(1);
    }

    //flushBufferToFile();
    //flushBufferToFileMultiValue();
    //flushBufferToFileMultiValueByteArray();
    //m_file.close();
}
