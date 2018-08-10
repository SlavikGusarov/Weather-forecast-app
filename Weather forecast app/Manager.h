//
//  Manager.hpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//


#pragma once

#include "Model.h"

// Синглтон класс, который вызывает ViewController и получает экземпляр Model
class Manager
{
public:
    static Manager* getInstance();
    ~Manager();
    Model* getModel();
protected:
    Manager();
    
private:
    Manager(Manager const&) = delete;
    Manager& operator= (Manager const&) = delete;
    
    Model *m_model;
    static Manager* _instance;
};
