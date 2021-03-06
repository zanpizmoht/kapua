/*******************************************************************************
 * Copyright (c) 2017, 2020 Red Hat Inc and others.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Red Hat Inc - initial API and implementation
 *     Eurotech
 *******************************************************************************/
package org.eclipse.kapua.sso.provider.generic;

import com.google.common.base.Strings;
import org.eclipse.kapua.sso.exception.SsoException;
import org.eclipse.kapua.sso.exception.SsoIllegalArgumentException;
import org.eclipse.kapua.sso.exception.uri.SsoIllegalUriException;
import org.eclipse.kapua.sso.provider.AbstractSingleSignOnService;
import org.eclipse.kapua.sso.provider.generic.setting.GenericSsoSetting;
import org.eclipse.kapua.sso.provider.generic.setting.GenericSsoSettingKeys;
import org.eclipse.kapua.sso.provider.SingleSignOnUtils;
import org.eclipse.kapua.sso.provider.setting.SsoSetting;

import java.net.URI;
import java.util.Optional;

/**
 * The generic SingleSignOn service class.
 */
public class GenericSingleSignOnService extends AbstractSingleSignOnService {

    private static final String AUTH_WELL_KNOWN_KEY = "authorization_endpoint";
    private static final String LOGOUT_WELL_KNOWN_KEY = "end_session_endpoint";
    private static final String TOKEN_WELL_KNOWN_KEY = "token_endpoint";

    private final GenericSsoSetting genericSettings;

    public GenericSingleSignOnService() {
        this(SsoSetting.getInstance(), GenericSsoSetting.getInstance());
    }

    public GenericSingleSignOnService(final SsoSetting ssoSettings, final GenericSsoSetting genericSettings) {
        super(ssoSettings);
        this.genericSettings = genericSettings;
    }

    @Override
    protected String getAuthUri() throws SsoException {
        try {
            final Optional<URI> uri = SingleSignOnUtils.getConfigUri(AUTH_WELL_KNOWN_KEY, getOpenIdConfPath());
            return uri.orElseThrow(() -> new SsoIllegalUriException(AUTH_WELL_KNOWN_KEY, null)).toString();
        } catch (SsoException se) {
            String authUri = genericSettings.getString(GenericSsoSettingKeys.SSO_OPENID_SERVER_ENDPOINT_AUTH);
            if (Strings.isNullOrEmpty(authUri)) {
                throw se;
            }
            return authUri;
        }
    }

    @Override
    protected String getTokenUri() throws SsoException {
        try {
            final Optional<URI> uri = SingleSignOnUtils.getConfigUri(TOKEN_WELL_KNOWN_KEY, getOpenIdConfPath());
            return uri.orElseThrow(() -> new SsoIllegalUriException(TOKEN_WELL_KNOWN_KEY, null)).toString();
        } catch (SsoException se) {
            String tokenUri = genericSettings.getString(GenericSsoSettingKeys.SSO_OPENID_SERVER_ENDPOINT_TOKEN);
            if (Strings.isNullOrEmpty(tokenUri)) {
                throw se;
            }
            return tokenUri;
        }
    }

    @Override
    protected String getLogoutUri() throws SsoException {
        try {
            final Optional<URI> uri = SingleSignOnUtils.getConfigUri(LOGOUT_WELL_KNOWN_KEY, getOpenIdConfPath());
            return uri.orElseThrow(() -> new SsoIllegalUriException(LOGOUT_WELL_KNOWN_KEY, null)).toString();
        } catch (SsoException se) {
            String logoutUri = genericSettings.getString(GenericSsoSettingKeys.SSO_OPENID_SERVER_ENDPOINT_LOGOUT);
            if (Strings.isNullOrEmpty(logoutUri)) {
                throw se;
            }
            return logoutUri;
        }
    }

    /**
     * Get the OpenID configuration path.
     *
     * @throws SsoIllegalArgumentException if it cannot retrieve the OpenID configuration path
     * @return a String representing the OpenID configuration URL.
     */
    private String getOpenIdConfPath() throws SsoIllegalArgumentException {
        String issuerUri = genericSettings.getString(GenericSsoSettingKeys.SSO_OPENID_JWT_ISSUER_ALLOWED);
        if (Strings.isNullOrEmpty(issuerUri)) {
            throw new SsoIllegalUriException(GenericSsoSettingKeys.SSO_OPENID_JWT_ISSUER_ALLOWED.key(), issuerUri);
        }
        return SingleSignOnUtils.getOpenIdConfPath(issuerUri);
    }
}
