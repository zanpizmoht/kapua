/*******************************************************************************
 * Copyright (c) 2018, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.device.management.asset.internal.exception;

import org.eclipse.kapua.service.device.management.message.response.KapuaResponseCode;

public class AssetGetManagementException extends AssetManagementResponseException {

    public AssetGetManagementException(KapuaResponseCode responseCode, String exceptionMessage, String exceptionStack) {
        super(AssetManagementResponseErrorCodes.ASSET_GET_ERROR, responseCode, exceptionMessage, exceptionStack);
    }
}
