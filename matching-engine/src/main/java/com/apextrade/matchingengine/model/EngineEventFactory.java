package com.apextrade.matchingengine.model;

import com.lmax.disruptor.EventFactory;

public class EngineEventFactory implements EventFactory<EngineEvent> {
    @Override
    public EngineEvent newInstance() {
        return new EngineEvent();
    }
}
