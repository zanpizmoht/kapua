/*******************************************************************************
 * Copyright (c) 2019, 2020 Eurotech and/or its affiliates and others
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Eurotech - initial API and implementation
 *******************************************************************************/
package org.eclipse.kapua.service.scheduler.trigger.definition.quartz;

import org.eclipse.kapua.commons.model.query.AbstractKapuaQuery;
import org.eclipse.kapua.model.id.KapuaId;
import org.eclipse.kapua.service.scheduler.trigger.definition.TriggerDefinitionQuery;

/**
 * {@link TriggerDefinitionQuery} implementation.
 *
 * @since 1.1.0
 */
public class TriggerDefinitionQueryImpl extends AbstractKapuaQuery implements TriggerDefinitionQuery {

    /**
     * Constructor
     *
     * @param scopeId The scope {@link KapuaId} of the {@link TriggerDefinitionQuery}
     */
    public TriggerDefinitionQueryImpl(KapuaId scopeId) {
        super(scopeId);
    }
}
