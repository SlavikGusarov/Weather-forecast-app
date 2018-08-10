//
//  MySignal.cpp
//  Weather forecast app
//
//  Created by air on 09.08.18.
//  Copyright © 2018 Slavik Gusarov. All rights reserved.
//

#include "MySignal.hpp"

MySignal::~MySignal()
{
    m_functions.clear();
}

// добавлять слушателей
void MySignal::connect(int64_t slot, SignalFunc func)
{
    m_functions.insert(std::make_pair(slot, func));
}

// оповещать
void MySignal::operator()()
{
    for (auto funcPair : m_functions)
    {
        funcPair.second();
    }
}

void MySignal::disconnect(int64_t slot)
{
    //std::map<int64_t, std::function<void()>>::iterator it;
    auto it = m_functions.find(slot);
    
    if(it != m_functions.end())
    {
        m_functions.erase(it);
    }
}

void MySignal::disconnect_all()
{
    m_functions.clear();
}