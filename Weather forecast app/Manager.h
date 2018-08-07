//
//  Manager.hpp
//  Weather forecast app
//
//  Created by air on 04.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#pragma once

//#include "Model.h"

// Синглтон класс, который вызывает ViewController и получает экземпляр Model
class Manager
{
public:
    static Manager& Instance()
    {
        static Manager manager;
        return manager;
    }
private:
    Manager();
    ~Manager();
    
    Manager(Manager const&);
    Manager& operator= (Manager const&);
    
    //Model m_model;
};
