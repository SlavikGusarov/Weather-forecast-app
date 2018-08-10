//
//  MySignal.hpp
//  Weather forecast app
//
//  Created by air on 09.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#pragma once

#include <map>
#include <functional>
#include <string>

enum Action
{
    Action_NewDocument = 0,
    Action_NewEvent,
    Action_NewDog
};

typedef std::function<void()> SignalFunc;

class MySignal
{
public:
    ~MySignal();
    
    // добавлять слушателей
    void connect(int64_t slot, SignalFunc func);
    // оповещать
    void operator()();
    //
    void disconnect_all();
    
    void disconnect(int64_t slot);
private:
    // слушатель
    std::map<int64_t, SignalFunc > m_functions;
};