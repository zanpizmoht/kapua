/*******************************************************************************
 * Copyright (c) 2016, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *     Red Hat Inc
 *******************************************************************************/
package org.eclipse.kapua.service.device.management.snapshot.message.internal;

import org.eclipse.kapua.message.internal.KapuaMessageImpl;
import org.eclipse.kapua.service.device.management.message.request.KapuaRequestMessage;

/**
 * Device snapshot request message.
 */
public class SnapshotRequestMessage extends KapuaMessageImpl<SnapshotRequestChannel, SnapshotRequestPayload> implements KapuaRequestMessage<SnapshotRequestChannel, SnapshotRequestPayload> {

    private static final long serialVersionUID = 1L;

    @Override
    public Class<SnapshotRequestMessage> getRequestClass() {
        return SnapshotRequestMessage.class;
    }

    @Override
    public Class<SnapshotResponseMessage> getResponseClass() {
        return SnapshotResponseMessage.class;
    }

}
