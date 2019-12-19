###############################################################################
# Copyright (c) 2017, 2019 Eurotech and/or its affiliates and others
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Eurotech
###############################################################################
@tag
@integration

Feature: Tag Service
  Tag Service is responsible for CRUD operations on Tags. This service is currently
  used to attach tags to Devices, but could be used to tag eny kapua entity, like
  User for example.

  Scenario: Start event broker for all scenarios
    Given Start Event Broker

  Scenario: Start datastore for all scenarios
    Given Start Datastore

  Scenario: Start broker for all scenarios
    Given Start Broker

  Scenario: Creating Unique Tag Without Description
  Login as kapua-sys, go to tags, try to create a tag with unique name without description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" without description
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Creating Non-unique Tag Without Description
  Login as kapua-sys, go to tags, try to create a tag with non-unique name without description.
  Kapua should return Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" without description
    Given I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name Tag123 already exists."
    When I create tag with name "Tag123" without description
    Then An exception was thrown
    Then I logout

  Scenario: Creating Tag With Short Name Without Description
  Login as kapua-sys, go to tags, try to create a tag with short name without description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "abc" without description
    And Tag with name "abc" is searched
    Then Tag with name "abc" is found
    And I logout

  Scenario: Creating Tag With Too Short Name Without Description
  Login as kapua-sys, go to tags, try to create a tag with too short name without description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Then I expect the exception "KapuaException" with the text "Name is too short"
    When I create tag with name "a" without description
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Long Name Without Description
  Login as kapua-sys, go to tags, try to create a tag with long (255 characters) name without description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" without description
    And Tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" is searched
    Then Tag with name "Y5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" is found
    And I logout

  Scenario: Creating Tag With Too Long Name Without Description
  Login as kapua-sys, go to tags, try to create a tag with too long (256 characters) name without description.
  Kapua should return Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Then I expect the exception "KapuaException" with the text "*"
    When I create tag with name "aY5gJ7o5XPkLBBFttelFa6tKTfF2G905xbQL7MTpoKcW8hDnXUORC0Rv0z6MJm1vKZPt6Wm6EB7RiJrP0D0hi28R2272J5inIlA7KiDxSKljwX4N7zW8RK7fwhUkwemA5qyF2DQ2DncXTUxsyAlXhh9qIJ43cPC7lSWyTNUFnMshYlLtB2ArnXPgLDQLooJlfdn6qbwTnNUOxML0OYrVoV1spfsZQEYsmFk9r53mfLajIfxDeHtoEShDxnHL4fgh" without description
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Permitted Symbols In Name Without Description
  Login as kapua-sys, go to tags, try to create a tag name with permitted ('-' and '_') symbols without description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag-12_3" without description
    And Tag with name "Tag-12_3" is searched
    Then Tag with name "Tag-12_3" is found
    And No exception was thrown
    And I logout

  Scenario: Creating Tag With Invalid Symbols In Name Without Description
  Login as kapua-sys, go to tags, try to create a tag name with invalid symbols without description.
  Kapua should return Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag@" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag!" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag&#34123" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag$" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag#" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag%" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag&" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag'" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag()" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag=" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag»" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÇ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag>" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag<" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag:" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag;" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag-" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag." without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag," without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag€" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag‹" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag›" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag*" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tagı" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag–" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag°" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag·" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag‚" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag_" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag±" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagŒ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag„" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag‰" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag?" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag“" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag‘" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag”’" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÉ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagØ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag∏" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag{}" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag|" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÆ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tagæ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÒ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÔ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÓ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÌ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÏ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÎÍ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÅ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag«" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag◊" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÑ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tagˆ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag¯" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "TagÈ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tagˇ" without description
    Then An exception was thrown
    Then I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "Tag¿" without description
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag Without a Name And Without Description
  Login as kapua-sys, go to tags, try to create a tag name without a name.
  Kapua should return an error.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Then I expect the exception "Exception"
    When I create tag with name "" without description
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Numbers In Name Without Description
  Login as kapua-sys, go to tags, try to create a tag that contains numbers.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "12345" without description
    And Tag with name "12345" is searched
    Then Tag with name "12345" is found
    And I logout

  Scenario: Creating Unique Tag With Unique Description
  Login as kapua-sys, go to tags, try to create a unique tag with unique description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "Description-@12#$456"
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Creating Unique Tag With Non-unique Description
  Login as kapua-sys, go to tags, try to create two unique tags with non-unique descriptions.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "Description1"
    And I create tag with name "Tag456" and description "Description1"
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    When Tag with name "Tag456" is searched
    And Tag with name "Tag456" is found
    And I logout

  Scenario: Creating Non-Unique Tag With Valid Description
  Login as kapua-sys, go to tags, try to create non-unique tag with valid Description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "Description1"
    Given I expect the exception "KapuaDuplicateNameException"
    When I create tag with name "Tag123" and description "Description1"
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Short Name With Valid Description
  Login as kapua-sys, go to tags, try to create tag with short name with valid Description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag" and description "Valid description 123"
    And Tag with name "Tag" is searched
    Then Tag with name "Tag" is found
    And I logout

  Scenario: Creating Tag With Too Short Name With Valid Description
  Login as kapua-sys, go to tags, try to create tag with too short name with valid description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception"
    When I create tag with name "t" and description "Valid description 123"
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Long Name With Valid Description
  Login as kapua-sys, go to tags, try to create tag with long name with valid description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" and description "Valid description 123"
    And Tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" is searched
    Then Tag with name "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" is found
    And I logout

  Scenario: Creating Tag With Too Long Name With Valid Description
  Login as kapua-sys, go to tags, try to create tag with too long name with valid description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "KapuaException"
    When I create tag with name "aoAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj" and description "Valid description 123"
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Permitted Symbols In Name With Valid Description
  Login as kapua-sys, go to tags, try to create tag with permitted symbols in name with valid description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag_12-3" and description "Valid description 123"
    And Tag with name "Tag_12-3" is searched
    Then Tag with name "Tag_12-3" is found
    And I logout

  Scenario: Creating Tag With Invalid Symbols In Name With Valid Description
  Login as kapua-sys, go to tags, try to create a tag with invalid symbols with valid description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception"
    When I create tag with name "Tag@123" and description "Valid description 123"
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag Without a Name And With Valid Description
  Login as kapua-sys, go to tags, try to create a tag without a name with valid description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "KapuaIllegalNullArgumentException"
    When I create tag with name "" and description "Valid description 123"
    Then An exception was thrown
    And I logout

  Scenario: Creating Tag With Numbers In Name With Valid Description
  Login as kapua-sys, go to tags, try to create a tag with numbers in name with valid description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "Valid-description@33-2"
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Creating Unique Tag With Short Description
  Login as kapua-sys, go to tags, try to create a tag with short description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "a"
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Creating Unique Tag With Long Description
  Login as kapua-sys, go to tags, try to create a tag with long description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" and description "oAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj"
    And Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Creating Unique Tag With Too Long Description
  Login as kapua-sys, go to tags, try to create a tag with too long description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception"
    When I create tag with name "Tag123" and description "aoAB7rpR552NlNY0TV8G4h7pikTASljfgRzc50ZSXBX5finW69LHoExMG3gyYpOeboQ01plWuF74qrYT2fvgtjmpLVn7UkbAVWvok7kDodu3rJGqaHIIBIxdAm1FhoWM0sc9ROSeEyv0RV1WVH2Fey4eVFf5aqG3T6hSwUNpJFblaZvfLoh3f9aBPNibEsVFSmqvJwdH3Vi1q8NHfv3hlTUxZidLCphUSTGaB8Yecp7mJJXVM1OwXCpiOcyGc5Uj"
    Then An exception was thrown
    And I logout

  Scenario: Changing Tag's Name To Unique One
  Login as kapua-sys, go to tags, try to edit tag's name into a unique one.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag name is changed into name "Tag2"
    And Tag with name "Tag2" is searched
    Then Tag with name "Tag2" is found
    When Tag with name "Tag1" is searched
    Then No tag was found
    And I logout

  Scenario: Changing Tag's Name To Non-Unique One
  Login as kapua-sys, go to tags, try to edit tag's name to non-unique one.
  Kapua should throw Exception
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And I create tag with name "Tag2" without description
    Given I expect the exception "KapuaDuplicateNameException" with the text "An entity with the same name Tag1 already exists."
    When Tag name is changed into name "Tag1"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Tag's Name To Short One Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to short one.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag name is changed into name "abc"
    And Tag with name "abc" is searched
    Then Tag with name "abc" is found
    And I logout

  Scenario: Changing Tag's Name To a Too Short One Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a too short one.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaException" with the text "*"
    And Tag name is changed into name "a"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Tag's Name To a Long One Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a long (255) one.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag name is changed into name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"
    And Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is searched
    Then Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is found
    And I logout

  Scenario: Changing Tag's Name To a Too Long One Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a too long (256) one.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaException" with the text "*"
    When Tag name is changed into name "aYXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Tag's Name To Contain Permitted Symbols In Name Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a name with permitted symbols.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag name is changed into name "T-a-g_1"
    And Tag with name "T-a-g_1" is searched
    Then Tag with name "T-a-g_1" is found
    And I logout

  Scenario: Changing Tag's Name To Contain Invalid Symbols In Name Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a name with invalid symbols.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    Given I expect the exception "KapuaException" with the text "*"
    When Tag name is changed into name "Tag@1#2?*=)3"
    Then An exception was thrown
    Then I logout

  Scenario: Deleting Tag's Name And Leaving It Empty Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to an empty name.
  Kapua should throw Exception, name is mandatory.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    Given I expect the exception "Exception" with the text "*"
    When Tag name is changed into name ""
    Then An exception was thrown
    Then I logout

  Scenario: Editing Tag's Name To Contain Numbers Without Description
  Login as kapua-sys, go to tags, try to edit tag's name to a name that contains numbers.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag name is changed into name "Tag0123456789"
    And Tag with name "Tag0123456789" is searched
    Then Tag with name "Tag0123456789" is found
    And I logout

  Scenario: Changing Tag's Description To Uniqe One
  Login as kapua-sys, go to tags, try to edit tag's description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag description is changed into "Valid description 123"
    Then No exception was thrown
    When I create tag with name "Tag2" and description "Description for testing"
    And Tag description is changed into "Description not for testing anymore"
    Then No exception was thrown
    And I logout

  Scenario: Changing Tag's Description To Non-Uniqe One
  Login as kapua-sys, go to tags, try to edit tag's description to a non-unique one.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" and description "Description 123"
    And I create tag with name "Tag2" and description "Description 567"
    And Tag description is changed into "Description 123"
    Then No exception was thrown
    And I logout

  Scenario: Changing Description On Tag With Non-unique Name
  Login as kapua-sys, go to tags, try to edit non-unique tag's description.
  Kapua should throw exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    Given I expect the exception "Exception" with the text "*"
    When I create tag with name "Tag1" without description
    Then An exception was thrown
    Given I expect the exception "Exception" with the text "*"
    When Tag description is changed into "Description 123"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Description On Tag With Short Name
  Login as kapua-sys, go to tags, try to edit description on a tag with too short name.
  Kapua should not throw any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "abc" without description
    And Tag description is changed into "Description 123"
    Then No exception was thrown
    And I logout

  Scenario: Changing Description On Tag With Too Short Name
  Login as kapua-sys, go to tags, try to edit description on a tag with too short Name.
  Kapua should throw an Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception" with the text "*"
    When I create tag with name "a" without description
    Then An exception was thrown
    And Tag description is changed into "Description"
    Then I logout

  Scenario: Changing Description On Tag With Long Name
  Login as kapua-sys, go to tags, try to edit description on a tag with long name.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" without description
    And Tag description is changed into "Description 123"
    And Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is searched
    Then Tag with name "YXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" is found
    And I logout

  Scenario: Changing Description On Tag With Too Long Name
  Login as kapua-sys, go to tags, try to edit description on a tag with long name.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception" with the text "*"
    When I create tag with name "aYXZb6s4L1f6Xk9J23S5RcNcH4Befzk4fg1fDi0PkIbCGtaIN50lWeklthY7Ngo06ss6lmUcqaHiChWjXYdqlcn1UMyqCHcuP4eG0qc9h7a9FLlnXgiFvcAQfvki8iwTPVEdEpBzOWZoWEssb9v966k0tSeQye4yxFC2FyR2SlNZTW06D0krB6zjKa8k5t1BJ2HbJwj5cp8Gsabjyk8lEtlMBeDLqCJv3ik3MZhySD1UvXMkWpOPZoixik8tCBHX" without description
    Then An exception was thrown
    Given I expect the exception "Exception" with the text "*"
    And Tag description is changed into "Description 123"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Description On Tag With Permitted Symbols
  Login as kapua-sys, go to tags, try to edit description on a tag with permitted symbols.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "T_a_g-1" without description
    And Tag description is changed into "Description 123"
    Then No exception was thrown
    And I logout

  Scenario: Changing Description On Tag With Invalid Symbols In Name
  Login as kapua-sys, go to tags, try to edit description on a tag with invalid symbols.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception" with the text "*"
    When I create tag with name "Tag@123" without description
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When Tag description is changed into "Description"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Description On Tag Without a Name
  Login as kapua-sys, go to tags, try to edit description on a tag with without a name.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "Exception" with the text "*"
    When I create tag with name "" without description
    Then An exception was thrown
    Given I expect the exception "NullPointerException"
    When Tag description is changed into "Description 123"
    Then An exception was thrown
    Then I logout

  Scenario: Changing Description On Tag With Numbers In Name
  Login as kapua-sys, go to tags, try to edit description on a tag with with numbers in name.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag123" without description
    And Tag description is changed into "Description 123"
    Then No exception was thrown
    When Tag with name "Tag123" is searched
    Then Tag with name "Tag123" is found
    And I logout

  Scenario: Changing Description On Tag With Short Description
  Login as kapua-sys, go to tags, try to edit description on a tag with with short description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" and description "a"
    And Tag description is changed into "b"
    Then No exception was thrown
    And I logout

  Scenario: Changing Description On Tag With Long Description
  Login as kapua-sys, go to tags, try to edit description on a tag with long (255) description.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" and description "mrZ4vBeOJbGkSlfzSHMY3Dj7gLO3E5SZFrtv7X4RF5LX1OWhRhBaRPubBJSglhS9ueguyStqJOcDs49mMVyuM2E08aPxcAMasSi6KWXmRcQaXl99oyFTScQT4ILK7I7EKuWFArivwLZkEPeK52OKnZjLxer8WGQ88CDqrooUUYt0lIOytrAGftGBO69DcIEjFrs73Mgyec0MvKkVeYYQ3dzDez2tGHPRTx19TVxHGtem52JOT6H7g0I3eGX5Ju0"
    And Tag description is changed into "Description 123"
    Then No exception was thrown
    And I logout

  Scenario: Changig Description On Tag With Too Long Description
  Login as kapua-sys, go to tags, try to edit description on a tag with too long (256) description.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    Given I expect the exception "KapuaException" with the text "*"
    When I create tag with name "Tag1" and description "amrZ4vBeOJbGkSlfzSHMY3Dj7gLO3E5SZFrtv7X4RF5LX1OWhRhBaRPubBJSglhS9ueguyStqJOcDs49mMVyuM2E08aPxcAMasSi6KWXmRcQaXl99oyFTScQT4ILK7I7EKuWFArivwLZkEPeK52OKnZjLxer8WGQ88CDqrooUUYt0lIOytrAGftGBO69DcIEjFrs73Mgyec0MvKkVeYYQ3dzDez2tGHPRTx19TVxHGtem52JOT6H7g0I3eGX5Ju0"
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When Tag description is changed into "Description"
    Then An exception was thrown
    Then I logout

  Scenario: Deleting existing tag
  Login as kapua-sys, go to tags, create a tag and delete it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And I create tag with name "Tag2" and description "Tag with descriprion"
    And Tag with name "Tag1" is searched
    And Tag with name "Tag1" is found and deleted
    And Tag with name "Tag2" is searched
    And Tag with name "Tag2" is found and deleted
    And Tag with name "Tag1" is searched
    Then No tag was found
    When Tag with name "Tag2" is searched
    Then No tag was found
    And I logout

  Scenario: Deleting Unexisting Tag
  Login as kapua-sys, go to tags, delete an unexisting tag.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is found and deleted
    Given I expect the exception "NullPointerException" with the text "*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When Tag with name "Tag1" is found and deleted
    Then An exception was thrown
    Then I logout

  Scenario: Deleting Existing Tag And Creating It Again With Same Name
  Login as kapua-sys, go to tags, delete an existing tag and creating it again with the same name.
  Kapua should not throw any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    When I create tag with name "Tag1" without description
    And Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is found and deleted
    When I create tag with name "Tag1" without description
    And Tag with name "Tag1" is searched
    Then Tag with name "Tag1" is found
    And No exception was thrown
    And I logout

  Scenario: Adding Regular Tag Without Description To Device
  Login as kapua-sys, go to tags, create a tag.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
  Check if device is in asigned devices of a tag.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    When I create tag with name "Tag123" without description
    Given A device named "Device1"
    And I asign tag to device
    Given Tag is assigned to device
    And No exception was thrown
    Then I logout

  Scenario: Adding Same Regular Tag Without Description To Device
  Login as kapua-sys, go to tags, create a tag.
  Go to devices, select a device and add created tag to it. Again add the tag to the same device.
  Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    When I create tag with name "Tag123" without description
    Given A device named "Device1"
    And I asign tag to device
    Given Tag is assigned to device
    And No exception was thrown
    Given I expect the exception "KapuaException" with the text "*"
    When I asign tag to device
    Then An exception was thrown
    Then I logout

  Scenario: Adding 100 Tags Without Description To Device
  Login as kapua-sys, go to tags, create 100 tags.
  Go to devices, select a device and add created tags to it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    When A device named "Device1"
    Given I create 100 tags without description and asign them to device
    When Tag with name "Tag003" is searched
    Then Tag with name "Tag003" is found
    Given Tag is assigned to device
    Then No exception was thrown
    When Tag with name "Tag099" is searched
    Then Tag with name "Tag099" is found
    Given Tag is assigned to device
    Then No exception was thrown
    When Tag with name "Tag000" is searched
    Then Tag with name "Tag000" is found
    Given Tag is assigned to device
    Then No exception was thrown
    And I logout

  Scenario: Adding Tag With Long Name Without Description To Device
  Login as kapua-sys, go to tags, create a tag with long (255) name.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "FxJpmQN9CU3ruFCAGtPDmKymN88CK7rn5L1AAYH184hCaxEpJsOQWKc3ACV2Gw44yWFz0o74rnsCabGHmX7azzplDPAe4mVYmHGLnMmlliQUpljJYB5i1Wq4flevCI8lIjZQ7UT7ll6I2C4eqvhXmt4GOD50bhiLzMDDZJeXXC8IjCidnz60QmbzUxpRC1YP8MQqosesjER2xm4jPrk3eH0egSwxvnPCeAWTXtSHeejOFVKLL78IW1xlhXkbOCh" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    And I logout

  Scenario: Adding Tag With Short Name Without Description To Device
  Login as kapua-sys, go to tags, create a tag with short (3) name.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "abc" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    And I logout

  Scenario: Adding Tag With Special Symbols Without Description To Device
  Login as kapua-sys, go to tags, create a tag with name that contains permited special symbols.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "T-a-g_1_" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    And I logout

  Scenario: Adding Tag With Numbers Without Description To Device
  Login as kapua-sys, go to tags, create a tag with name that contains numbers.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "Tag1234567890" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    And I logout

  Scenario: Deleting Tag From Device
  Login as kapua-sys, go to tags, create a tag.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
  Go to devices, select tag and remove it from selected device
  Check if tag is removed
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "Tag1" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    Given I unassign tag from device
    And I expect the exception "KapuaException" with the text "*"
    When Tag is assigned to device
    Then An exception was thrown
    Then I logout

  Scenario: Adding Previously Deleted Tag From Device Again
  Login as kapua-sys, go to tags, create a tag.
  Go to devices, select a device and add created tag to it.
  Kapua should not return any errors.
  Go to devices, select tag and remove it from selected device
  Check if tag is removed
  Again asign removed tag to device.
  Kapua should not return any errors
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I create tag with name "Tag1" without description
    When I asign tag to device
    Then Tag is assigned to device
    And No exception was thrown
    Given I unassign tag from device
    And I expect the exception "KapuaException" with the text "*"
    When Tag is assigned to device
    Then An exception was thrown
    Given I asign tag to device
    And Tag is assigned to device
    Then No exception was thrown
    Then I logout

  Scenario: Adding "Empty" Tag To Device
    Login as kapua-sys, go to devices, try to a tag without selecting anything.
    Kapua should throw Exception.
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I configure the device registry service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 10    |
    Given A device named "Device1"
    And I expect the exception "NullPointerException" with the text "*"
    When I asign tag to device
    Then An exception was thrown
    Then I logout

  Scenario: Stop broker after all scenarios
    Given Stop Broker

  Scenario: Stop event broker for all scenarios
    Given Stop Event Broker

  Scenario: Stop datastore after all scenarios
    Given Stop Datastore

