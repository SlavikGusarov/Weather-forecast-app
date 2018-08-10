//
//  Manager.cpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "Manager.h"

Manager* Manager::_instance = 0;

Manager::Manager()
{
    m_model = new Model();
}

Manager::~Manager()
{
    delete m_model;
    m_model = nullptr;
}

Manager* Manager::getInstance()
{
    if(_instance == 0)
    {
        _instance = new Manager();
    }
    return _instance;
}

Model* Manager::getModel()
{
    return m_model;
}