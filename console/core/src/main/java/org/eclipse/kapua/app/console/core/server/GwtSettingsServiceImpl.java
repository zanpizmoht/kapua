/*******************************************************************************
 * Copyright (c) 2017 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.app.console.core.server;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import org.eclipse.kapua.app.console.core.server.util.SsoHelper;
import org.eclipse.kapua.app.console.core.server.util.SsoLocator;
import org.eclipse.kapua.app.console.core.shared.model.GwtProductInformation;
import org.eclipse.kapua.app.console.core.shared.service.GwtSettingsService;
import org.eclipse.kapua.app.console.module.api.setting.ConsoleSetting;
import org.eclipse.kapua.app.console.module.api.setting.ConsoleSettingKeys;

import java.util.UUID;

public class GwtSettingsServiceImpl extends RemoteServiceServlet implements GwtSettingsService {

    private static final long serialVersionUID = -6876999298300071273L;
    private static final ConsoleSetting SETTINGS = ConsoleSetting.getInstance();

    @Override
    public GwtProductInformation getProductInformation() {
        GwtProductInformation result = new GwtProductInformation();
        result.setBackgroundCredits(SETTINGS.getString(ConsoleSettingKeys.LOGIN_BACKGROUND_CREDITS, ""));
        result.setInformationSnippet(SETTINGS.getString(ConsoleSettingKeys.LOGIN_GENERIC_SNIPPET, ""));
        result.setProductName(SETTINGS.getString(ConsoleSettingKeys.PRODUCT_NAME, ""));
        result.setCopyright(SETTINGS.getString(ConsoleSettingKeys.PRODUCT_COPYRIGHT, ""));
        return result;
    }

    @Override
    public String getSsoLoginUri() {
        return SsoLocator.getLocator(this).getService().getLoginUri(UUID.randomUUID().toString(), SsoHelper.getRedirectUri());
    }

    @Override
    public boolean getSsoEnabled() {
        return SsoLocator.getLocator(this).getService().isEnabled();
    }

    @Override
    public String getHomeUri() {
        return SETTINGS.getString(ConsoleSettingKeys.SITE_HOME_URI);
    }
}
