/*******************************************************************************
 * Copyright (c) 2019 Eurotech and/or its affiliates and others.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.sso.provider.keycloak;

import org.eclipse.kapua.sso.provider.keycloak.setting.KeycloakSsoSetting;
import org.eclipse.kapua.sso.provider.keycloak.setting.KeycloakSsoSettingKeys;

/**
 * The Keycloak SingleSignOn service utility class.
 */
public class KeycloakSingleSignOnUtils {

    private KeycloakSingleSignOnUtils() {
    }

    /**
     * Get the Keycloak realm.
     *
     * @return the Keycloak realm in the form of a String ('master' if no realm is found).
     */
    public static String getRealm() {
        return KeycloakSsoSetting.getInstance().getString(KeycloakSsoSettingKeys.KEYCLOAK_REALM, "master");
    }

}
