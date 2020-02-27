###############################################################################
# Copyright (c) 2019, 2020 Eurotech and/or its affiliates and others
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#     Eurotech - initial API and implementation
###############################################################################
@user
@userPermission
@integration

Feature: User Permission tests

  Scenario: Adding One Permission To User
    Create a new user kapua-a, with only one permission - user:read.
    After login kapua-a user should be able to search and find himself.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And I search for user with name "kapua-a"
    Then I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout

  Scenario: Adding Multiple Permissions To User
    Create a new kapua_a user with all permissions in the User domain.
    After login kapua_a should be able to read, add, edit and delete users.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | write  |
      | user   | delete |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    Then I search for user with name "kapua-b"
    And I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I change name to "updated-kapua-a"
    Then I search for user with name "kapua-b"
    And I find no user
    Then I search for user with name "updated-kapua-a"
    And I find user
      | name            | displayName  | email             | phoneNumber     | status  | userType |
      | updated-kapua-a | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I try to delete user "updated-kapua-a"
    Then I search for user with name "updated-kapua-a"
    And I find no user
    And I logout

  Scenario: Deleting a Permission
    Create a new user kapua-a, with only one permission - user:read.
    Login as kapua-a user, and verify that the permission is added correctly.
    As kapua-sys user delete the only added permission to the kapua_a user.
    After login, kapua_a user should get SubjectUnauthorizedException when doing a user search.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And I search for user with name "kapua-a"
    Then I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout
    When I login as user with name "kapua-sys" and password "kapua-password"
    Then I query for the last permission added to the new User
    And I find the last permission added to the new user
    And I delete the last permission added to the new User
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I search for user with name "kapua-a"
    And An exception was thrown
    And I logout

  Scenario: Adding Previously Deleted Permission
    Create a new user kapua-a, with only one permission - user:read.
    Login as kapua_a and verify that the permission is added correctly.
    As the kapua-sys user remove the only permission added to the kapua_a user.
    After login, kapua_a user should get SubjectUnauthorizedException when doing a user search.
    As kapua-sys user add the previously removed permission to the kapua-a user.
    Login as kapua-a user and verify that the permission is correctly added again.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And I search for user with name "kapua-a"
    Then I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout
    When I login as user with name "kapua-sys" and password "kapua-password"
    Then I query for the last permission added to the new User
    And I find the last permission added to the new user
    And I delete the last permission added to the new User
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I search for user with name "kapua-a"
    Then An exception was thrown
    And I logout
    When I login as user with name "kapua-sys" and password "kapua-password"
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then I search for user with name "kapua-a"
    And I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout

  Scenario: Adding Permissions To Parallel User
    Create two users, kapua-a and kapua-b in the same kapua-sys account.
    Add the needed user, account and access_info permissions to the kapua_a user.
    After login, kapua_a user should be able to add user:read permission to the kapua_b user.
    Login as kapua-b user and verify that the permission is correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain      | action |
      | user        | read   |
      | user        | write  |
      | account     | read   |
      | access_info | read   |
      | access_info | write  |
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-b | ToManySecrets123# | true    |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And I search for user with name "kapua-b"
    Then I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And Add permissions to the last created user
      | domain      | action |
      | user        | read   |
    And I logout
    When I login as user with name "kapua-b" and password "ToManySecrets123#"
    Then I search for user with name "kapua-a"
    And I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout

  Scenario:  Adding Permissions To Child User
    Create a new kapua-a user with user, account and access_info domain permissions in the kapua-sys account.
    Add a new account account-b, with a new kapua-b user with no permissions.
    After login, kapua_a user should be able to add user:read permission to the kapua_b user.
    Login as kapua-b user and verify that the permission is correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain      | action |
      | user        | read   |
      | user        | write  |
      | account     | read   |
      | access_info | read   |
      | access_info | write  |
    And Account
      | name      |
      | account-b |
    And I configure user service
      | type    | name                       | value |
      | boolean | infiniteChildEntities      | true  |
      | integer | maxNumberChildEntities     | 5     |
      | boolean | lockoutPolicy.enabled      | false |
      | integer | lockoutPolicy.maxFailures  | 3     |
      | integer | lockoutPolicy.resetAfter   | 300   |
      | integer | lockoutPolicy.lockDuration | 3     |
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 323 555 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-b | ToManySecrets123# | true    |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then Add permissions to the last created user
      | domain | action |
      | user   | read   |
    And I logout
    When I login as user with name "kapua-b" and password "ToManySecrets123#"
    Then I search for user with name "kapua-b"
    And I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 323 555 | ENABLED | INTERNAL |
    And I logout

    Scenario: Add User domain permissions to new user
      Create a new kapua-a user in the kapua-sys account.
      Add all permissions from the User domain to the kapua-a user.
      Login as kapua-a user and verify that all the permissions are added correctly.

      When I login as user with name "kapua-sys" and password "kapua-password"
      And I select account "kapua-sys"
      And A generic user
        | name    | displayName  | email             | phoneNumber     | status  | userType |
        | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
      And I add credentials
        | name    | password          | enabled |
        | kapua-a | ToManySecrets123# | true    |
      And Add permissions to the last created user
        | domain      | action |
        | user        | read   |
        | user        | write  |
        | user        | delete |
      Then I logout
      When I login as user with name "kapua-a" and password "ToManySecrets123#"
      And A generic user
        | name    | displayName  | email             | phoneNumber     | status  | userType |
        | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      Then I search for user with name "kapua-b"
      And I find user
        | name    | displayName  | email             | phoneNumber     | status  | userType |
        | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      And I change name to "kapua-ab"
      Then I search for user with name "kapua-b"
      And I find no user
      Then I search for user with name "kapua-ab"
      And I find user
        | name     | displayName  | email             | phoneNumber     | status  | userType |
        | kapua-ab | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      And I try to delete user "kapua-ab"
      Then I search for user with name "kapua-ab"
      And I find no user
      And I logout

  Scenario: Add Device domain permissions to new user
      Create a new kapua-a user in the kapua-sys account.
      Add all permissions from the Device domain to the kapua-a user.
      Login as kapua-a user and verify that all the permissions are added correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain      | action |
      | device      | read   |
      | device      | write  |
      | device      | delete |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then A device named "device-client-1"
    And I search for a device with the remembered ID
    Then I find the device
    When I update some device parameters
    Then The device was correctly updated
    And I delete the device with the remembered ID
    And I search for a device with the remembered ID
    Then There is no such device
    And I logout

  Scenario: Add Group domain permissions to new user
    Create a new kapua-a user in the kapua-sys account.
    Add all permissions from the Group domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain      | action |
      | group       | read   |
      | group       | write  |
      | group       | delete |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Given I create the group
      | scope | name         |
      | 1     | test_group_1 |
    Then I search for the group with name "test_group_1"
    And The group was found
    Then I update the group name to "updated_test_group_1"
    Then The group was correctly updated
    When I delete the group with name "updated_test_group_1"
    Then I search for the group with name "updated_test_group_1"
    And No group was found
    And I logout

  Scenario: Add Tag domain permissions to new user
    Create a new kapua-a user in the kapua-sys account.
    Add all permissions from the Tag domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain  | action |
      | tag     | read   |
      | tag     | write  |
      | tag     | delete |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Given I create a tag with name "tag_a"
    When Tag with name "tag_a" is searched
    Then I find a tag with name "tag_a"
    Then I find and delete tag with name "tag_a"
    And Tag with name "tag_a" is searched
    And No tag was found
    And I logout

  Scenario: Add Job domain permissions to new user
    Create a new kapua-a user in the kapua-sys account.
    Add permissions from the Job domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 323 444 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action  |
      | job    | read    |
      | job    | write   |
      | job    | delete  |
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Given A regular job creator with the name "job-a"
    When I create a new job entity from the existing creator
    When I search for the job in the database
    And The job entity matches the creator
    And I change the job name to "updated-job-a"
    When I search for the job in the database
    Then The job name is "updated-job-a"
    When I delete the job
    And I search for the job in the database
    Then There is no such job item in the database
    And I logout

  Scenario: Add Access Info domain permissions to new user
    Create a new kapua-a and kapua-b users in the kapua-sys account.
    Add permissions from the access_info domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly
    by performing permission add, search and delete on the kapua-b user.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain        | action |
      | access_info   | read   |
      | access_info   | write  |
      | access_info   | delete |
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-b | ToManySecrets123# | true    |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    And I logout
    When I login as user with name "kapua-b" and password "ToManySecrets123#"
    Then I search for user with name "kapua-b"
    And I find user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then I query for the last permission added to the new User
    And I find the last permission added to the new user
    And I delete the last permission added to the new User
    And I logout
    When I login as user with name "kapua-b" and password "ToManySecrets123#"
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I search for user with name "kapua-b"
    And An exception was thrown
    And I logout

  Scenario: Add Role domain permissions to new user
    Create a new kapua-a user in the kapua-sys account.
    Add permissions from the Role domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly.

    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | write  |
      | role   | delete |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Given I create the following role
      | scopeId | name      |
      | 1       | test_role |
    Then I search for the role with name "test_role"
    And The correct role entry was found
    When I update the role name to "updated_test_role"
    And I search for the role with name "updated_test_role"
    When I delete the role with name "updated_test_role"
    And I search for the role with name "updated_test_role"
    Then I find no roles
    And I logout

  Scenario: Add Datastore domain permissions to new user
    Create a new kapua-a user in the kapua-sys account.
    Add permissions from the Datastore domain to the kapua-a user.
    Login as kapua-a user and verify that all the permissions are added correctly.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And The device "test-device-1"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain     | action |
      | datastore  | read   |
      | datastore  | write  |
      | datastore  | delete |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    And I prepare a random message and save it as "RandomDataMessage"
    And I store the message "RandomDataMessage" and remember its ID as "RandomDataMessageId"
    And I refresh all indices
    When I search for a data message with ID "RandomDataMessageId" and remember it as "DataStoreMessage"
    Then The datastore message "DataStoreMessage" matches the prepared message "RandomDataMessage"
    When I delete the datastore message with ID "RandomDataMessageId"
    And I refresh all indices
    When I search for a data message with ID "RandomDataMessageId" and remember it as "ShouldBeNull"
    Then Message "ShouldBeNull" is null
    And I logout

    Scenario: Add Domain domain permissions to kapua-sys user
    Login as the kapua-sys user and select the kapua-sys account.
    Verify that the kapua-sys user has all of the permissions from the Credential domain.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    When I count the domain entries in the database
    Then I count 21
    And I create the domain
      | name          | actions             |
      | test_domain   | read, write, delete |
    When I search for the last created domain
    Then The domain matches the creator
    When I count the domain entries in the database
    Then I count 22
    When I delete the last created domain
    And I search for the last created domain
    Then There is no domain
    When I count the domain entries in the database
    Then I count 21
    And I logout

  Scenario: Add Domain domain permissions to new user
  Create a new kapua-a user in the kapua-sys account.
  Add all permissions from the Domain domain to the kapua-a user.
  After login the kapua-a user should get the SubjectUnauthorizedException when trying to create a new domain.
  Kapua-a user should be able to perform queries for the already created domain with no exceptions.
  After trying to perform a domain delete kapua-a user should get the SubjectUnauthorizedException.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain   | action |
      | domain   | read   |
      | domain   | write  |
      | domain   | delete |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I create the domain
      | name           | actions             |
      | test_domain1   | read, write, delete |
    Then An exception was thrown
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "An illegal null value was provided"
    When I search for the last created domain
    And An exception was thrown
    When I count the domain entries in the database
    Then I count 21
    And I logout
    When I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And I create the domain
      | name           | actions             |
      | test_domain2   | read, write, delete |
    When I count the domain entries in the database
    Then I count 22
    Then I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    Then I search for the last created domain
    And The domain matches the creator
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I delete the last created domain
    Then An exception was thrown
    When I count the domain entries in the database
    Then I count 22
    And I logout

  Scenario: Add Credential domain permissions to new user
  Create a new kapua-a user in the kapua-sys account.
  Add all permissions from the Credential domain to the kapua-a user.
  Login as kapua-a user and verify that all the permissions are added correctly.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain       | action |
      | credential   | read   |
      | credential   | write  |
      | credential   | delete |
      | user         | read   |
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-b | Kapua User b | kapua_b@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I logout
    When I login as user with name "kapua-a" and password "ToManySecrets123#"
    When I search for last created user's credentials
    Then I find 0 credentials
    And I add credentials
      | name    | password           | enabled |
      | kapua-b | ToManySecrets123#2 | true    |
    Then I search for last created user's credentials
    And I find 1 credentials
    And I delete the last created user's credential
    When I search for last created user's credentials
    Then I find 0 credentials
    And I logout

  Scenario: Add Device Event domain permissions to new user
  Create a new kapua-a user in the kapua-sys account.
  Add all permissions from the Broker domain to the kapua-a user, as well as the needed
  permissions from the device domain.
  Login as kapua-a user and verify that all device_event permissions are added correctly.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A device named "test_client1"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain       | action |
      | device_event | write  |
      | device_event | read   |
      | device_event | delete |
      | device       | read   |
      | device       | write  |
    And I logout
    Then I login as user with name "kapua-a" and password "ToManySecrets123#"
    And A "CREATE" event from device "test_client1"
    When I search for an event with the remembered ID
    Then The event matches the creator parameters
    And I delete the event with the remembered ID
    When I search for an event with the remembered ID
    Then There is no such event
    And I logout

  Scenario: Add Device Connection domain permissions to kapua-sys user
    Login as the kapua-sys user and select the kapua-sys account.
    Verify that the kapua-sys user has all of the permissions from the device_connection domain.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And I have the following connection
      | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
      | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I search for a connection with the client ID "testClient1"
    Then The connection details match
      | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
      | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    When I modify the connection details to
      | clientIp    | serverIp   | protocol | allowUserChange   |
      | 127.0.0.109 | 127.0.0.25 | udp      | true              |
    And I delete the existing connection
    When I search for a connection with the client ID "testClient1"
    Then No connection was found
    And I logout

  Scenario: Add Device Connection domain permissions to new user
  Create a new kapua-a user in the kapua-sys account.
  Add all permissions from the device_connection domain to the kapua-a user.
  Login as kapua-a user and verify that the permissions are added correctly.
  Kapua-a user should be able to perform queries for the already created connections with no exceptions.
  After trying to perform a connection edit or delete kapua-a user should get the SubjectUnauthorizedException.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name    | displayName  | email             | phoneNumber     | status  | userType |
      | kapua-a | Kapua User a | kapua_a@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | kapua-a | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain              | action  |
      | device_connection   | read    |
      | device_connection   | write   |
      | device_connection   | delete  |
    And I have the following connection
      | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
      | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    And I logout
    Then I login as user with name "kapua-a" and password "ToManySecrets123#"
    When I search for a connection with the client ID "testClient1"
    Then The connection details match
      | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
      | testClient1 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I delete the existing connection
    And An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I modify the connection details to
      | clientIp    | serverIp   | protocol | allowUserChange   |
      | 127.0.0.109 | 127.0.0.25 | udp      | true              |
    And An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I have the following connection
      | clientId    | clientIp    | serverIp   | protocol | allowUserChange   |
      | testClient2 | 127.0.0.101 | 127.0.0.10 | tcp      | true              |
    Then An exception was thrown
    When I search for a connection with the client ID "testClient2"
    Then No connection was found
    And I logout

  Scenario: Add Scheduler Permissions Without Job Permissions
  Creating "user1", adding permissions with scheduler domain without adding job permissions.
  "user1" should not have permissions to do anything as he is not authorized to do anything with jobs.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name    | password          | enabled |
      | user1   | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain    | action |
      | scheduler | write  |
      | scheduler | read   |
      | scheduler | delete |
    And I logout
    Then I login as user with name "user1" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    And I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "TestSchedule" and following properties
      | name     | type              | value |
      | interval | java.lang.Integer | 1     |
    Given I expect the exception "KapuaIllegalNullArgumentException" with the text "*"
    When I try to create a new trigger entity from the existing creator
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When I try to edit trigger name "TestSchedule1"
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When I try to delete last created trigger
    Then An exception was thrown
    Then I logout

  Scenario: Add Scheduler Permissions With Job Permissions
  Creating "user1", adding permissions with scheduler domain with adding job permissions.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | job    | write  |
      | job    | read   |
      | job    | delete |
    And I logout
    Then I login as user with name "user1" and password "ToManySecrets123#"
    And I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "TestSchedule" and following properties
      | name     | type              | value |
      | interval | java.lang.Integer | 1     |
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: scheduler:write:1:*"
    When I try to create a new trigger entity from the existing creator
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When I try to edit trigger name "TestSchedule1"
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When I try to delete last created trigger
    Then An exception was thrown
    Then I logout
    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Add permissions to the last created user
      | domain    | action |
      | scheduler | write  |
      | scheduler | read   |
      | scheduler | delete |
    And I logout
    Then I login as user with name "user1" and password "ToManySecrets123#"
    And I find scheduler properties with name "Interval Job"
    And A regular trigger creator with the name "TestSchedule" and following properties
      | name     | type              | value |
      | interval | java.lang.Integer | 1     |
    When I try to create a new trigger entity from the existing creator
    And I try to edit trigger name "TestSchedule1"
    And I try to delete last created trigger
    Then No exception was thrown
    And I logout

  Scenario: Add Endpoint Permission To The User
  Creating "user1", adding endpoint permissions to the user and test if user can work with endpoints.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I create endpoint with schema "endpoint1", domain "com" and port 20000
    And I logout
    Then I login as user with name "user1" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:read:"
    When I try to find endpoint with schema "endpoint1"
    Then An exception was thrown
    Then I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    And Add permissions to the last created user
      | domain        | action | targetScope |
      | endpoint_info | write  | 1           |
      | endpoint_info | read   | 1           |
      | endpoint_info | delete | 1           |
    Then I logout
    And I login as user with name "user1" and password "ToManySecrets123#"
    When I try to find endpoint with schema "endpoint1"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:write:*:*"
    When I create endpoint with schema "end2", domain "com" and port 20000
    Then An exception was thrown
    When I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: endpoint_info:delete:*:*"
    And I delete endpoint with schema "endpoint1"
    Then An exception was thrown
    Then I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    When I delete endpoint with schema "endpoint1"
    Then No exception was thrown
    And I logout

  Scenario: Adding Role:Read permission to user in same scope
  Login as kapua-sys.
  Create a few roles.
  Create a sample user in kapua-sys account (e.g. User0).
  Add Role:Read permission to user0.
  Login as user0 and query roles - no exception should be thrown.
  Try to create a role - it should not be possible without Role:Write permission.
  Try to edit a role - it should not be possible without Role:Write permission.
  Try to delete a role - it should not be possible without Role:Delete permission.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Then I query for the role "role1" in scope 1
    And The role was found
    And No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:delete:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    And I logout

    Scenario: Adding Account:Write permission to user in same scope
    Login as kapua-sys user on the kapua-sys account and add a new user0 user with
    the Account:Write permission to the kapua-sys account. Create a child account subAccount0.
    Login as user0 and perform actions on the subAccount0. Verify that only allowed actions are
    performed and the exception is thrown where needed.

      Given I login as user with name "kapua-sys" and password "kapua-password"
      And I select account "kapua-sys"
      And A generic user
        | name  | displayName  | email           | phoneNumber     | status  | userType |
        | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      And I add credentials
        | name  | password          | enabled |
        | user0 | ToManySecrets123# | true    |
      And Add permissions to the last created user
        | domain  | action |
        | account | write  |
      And Account
        | name        | scopeId |
        | subAccount0 | 1       |
    And I logout
    When I login as user with name "user0" and password "ToManySecrets123#"
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I search for the account with the remembered account Id
    And An exception was thrown
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I modify the account "subAccount0"
    And An exception was thrown
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I delete account "subAccount0"
    And An exception was thrown
    And I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I modify the account "kapua-sys"
    And An exception was thrown
    Then I expect the exception "SubjectUnauthorizedException" with the text "User does not have permission"
    When I delete account "kapua-sys"
    And An exception was thrown
    And I logout

      # TODO: still waiting for fix of issue #2776
#  Scenario: Adding Role:Read permission to user in same scope TWICE
#  Login as kapua-sys
#  Create a few roles
#  Create a sample user in kapua-sys account (e.g. User0)
#  Add Role:Read permission to user0
#  Again add Role:Read permission to user0
#  Kapua should throw an exception.
#
#    Given I login as user with name "kapua-sys" and password "kapua-password"
#    And Scope with ID 1
#    And I select account "kapua-sys"
#    And A generic user
#      | name  | displayName  | email           | phoneNumber     | status  | userType |
#      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
#    And Credentials
#      | name  | password          | enabled |
#      | user0 | ToManySecrets123# | true    |
#    And Add permissions to the last created user
#      | domain | action |
#      | role   | read   |
#    Given I expect the exception "KapuaException" with the text "*"
#    And Add permissions to the last created user
#      | domain | action |
#      | role   | read   |
#    Then An exception was thrown
#    Then I logout

  Scenario: Revoking Role:Read permission to user in same scope
  Login as kapua-sys
  Create a few roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read permission to user0
  Revoke Role:Read permission to user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then No exception was thrown
    Then I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Write permission to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Write permission to user0
  Login as user0 and try to query roles, it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete Role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking Role:Write permission to user in same scope
  Login as kapua-sys
  Create a few roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Write permission to user0
  Revoke Role:Read permission to user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission


    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role8     |
    Then An exception was thrown
    Then I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Delete permission to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Delete permission to user0
  Login as user0 and try to query roles, it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read and Role:Read permissions
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking Role:Delete permission to user in same scope
  Login as kapua-sys
  Create a few roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Delete permission to user0
  Revoke Role:Delete permission to user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role3"
    Then An exception was thrown
    Then I logout
    And I login as user with name "kapua-sys" and password "kapua-password"
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Read + Role:Write permissions to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Write permission to user0
  Login as user0 and try to query roles - no exception should be thrown
  Try to create a role - no exception should be thrown
  Try to edit a role - no exception should be thrown
  Try to delete a role - it should not be possible without Role:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then The role was found
    Then No exception was thrown
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then No exception was thrown
    When I update role "role1" to name "role6"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:delete:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Read + Role:Write permission to user and revoking Role:Write in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Write permission to user0
  Revoke Role:Write permission from user0
  Login as user0 and query roles - no exception should be thrown
  Try to create a role - it should not be possible without Role:Write permission
  Try to edit a role - it should not be possible without Role:Write permission
  Try to delete a role - it should not be possible without Role:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then The role was found
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:delete:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Read + Role:Write permission to user and revoking Role:Read in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Write permission to user0
  Revoke Role:Read permission from user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | write  |
      | role   | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Read + Role:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Delete permission to user0
  Login as user0 and try to query roles - no exception should be thrown
  Try to create a role - it should not be possible without Role:Write permission
  Try to edit a role - it should not be possible without Role:Write permission
  Try to delete a role - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then The role was found
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    When I delete the role "role2"
    When I query for the role "role2" in scope 1
    Then I find no roles
    Then I logout

  Scenario: Adding Role:Read + Role:Delete permission to user and revoking Role:Delete in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Delete permission to user0
  Revoke Role:Delete permission from user0
  Login as user0 and query roles - no exception should be thrown
  Try to create a role - it should not be possible without Role:Write permission
  Try to edit a role - it should not be possible without Role:Write permission
  Try to delete a role - it should not be possible without Role:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then The role was found
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:delete:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Read + Role:Delete permission to user and revoking Role:Read in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Read and Role:Delete permission to user0
  Revoke Role:Read permission from user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | delete |
      | role   | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Write + Role:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Write and Role:Delete permission to user0
  Login as user0 and try to query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | write  |
      | role   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Write + Role:Delete permission to user and revoking Role:Write in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Write and Role:Write permission to user0
  Revoke Role:Delete permission from user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | delete |
      | role   | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:write:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:Write + Role:Delete permission to user and revoking Role:Delete in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Role:Write and Role:Delete permission to user0
  Revoke Role:Write permission from user0
  Login as user0 and query roles - it should not be possible without Role:Read permission
  Try to create a role - it should not be possible without Role:Read permission
  Try to edit a role - it should not be possible without Role:Read permission
  Try to delete a role - it should not be possible without Role:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | write  |
      | role   | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I query for the role "role1" in scope 1
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I create the following roles
      | scopeId | name   |
      | 1       | role3  |
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I update role "role1" to name "role6"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: role:read:1:*"
    When I delete the role "role2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Role:All permissions to user in same scope
  Login as kapua-sys
  Create a few sample roles
  Create a sample user in kapua-sys account (e.g. User0)
  Add Account:ALL permission to user0
  Login as user0 and try to query roles - no exception should be thrown
  Try to create a role - no exception should be thrown
  Try to edit a role - no exception should be thrown
  Try to delete a role - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create the roles
      | name  |
      | role1 |
      | role2 |
    And Add permissions to the last created user
      | domain | action |
      | role   | read   |
      | role   | write  |
      | role   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I query for the role "role1" in scope 1
    Then No exception was thrown
    When I create the following roles
      | scopeId | name      |
      | 1       | role3     |
    Then No exception was thrown
    When I update role "role1" to name "role6"
    Then No exception was thrown
    When I delete the role "role2"
    Then No exception was thrown
    Then I logout

  Scenario: Adding Tag:Read permission to user in same scope
  Login as kapua-sys.
  Create a few tags.
  Create a sample user in kapua-sys account (e.g. User0).
  Add Tag:Read permission to user0.
  Login as user0 and query tags - no exception should be thrown.
  Try to create a tag - it should not be possible without Tag:Write permission.
  Try to edit a tag - it should not be possible without Tag:Write permission.
  Try to delete a tag - it should not be possible without Tag:Write permission.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create a tag with name "Tag1" and description "testni tag"
    And I create a tag with name "Tag2" and description "testni tag"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    And I find a tag with name "Tag1"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Test123"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:delete:1:*"
    Then I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking Tag:Read permission to user in same scope
  Login as kapua-sys
  Create a few tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read permission to user0
  Revoke Tag:Read permission to user0
  Login as user0 and query tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission


    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create a tag with name "Tag1" and description "testni tag"
    And I create a tag with name "Tag2" and description "testni tag"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Test123"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    Then I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Write permission to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Write permission to user0
  Login as user0 and try to query Tags, it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking Tag:Write permission to user in same scope
  Login as kapua-sys
  Create a few tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Write permission to user0
  Revoke Tag:Write permission to user0
  Login as user0 and query tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create a tag with name "Tag1" and description "testni tag"
    And I create a tag with name "Tag2" and description "testni tag"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Test123"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    Then I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Delete permission to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Delete permission to user0
  Login as user0 and try to query tags, it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read and Tag:Read permissions
  Try to delete a tag - it should not be possible without Tag:Read permission


    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking Tag:Delete permission from user in same scope
  Login as kapua-sys
  Create a few tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Delete permission to user0
  Revoke Tag:Delete permission to user0
  Login as user0 and query tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I configure the tag service
      | type    | name                   | value |
      | boolean | infiniteChildEntities  | true  |
      | integer | maxNumberChildEntities | 5     |
    And I create a tag with name "Tag1" and description "testni tag"
    And I create a tag with name "Tag2" and description "testni tag"
    And Add permissions to the last created user
      | domain | action |
      | tag    | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Test123"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    Then I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Read + Tag:Write permissions to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Write permission to user0
  Login as user0 and try to query tags - no exception should be thrown
  Try to create a tag - no exception should be thrown
  Try to edit a tag - no exception should be thrown
  Try to delete a tag - it should not be possible without Tag:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
      | tag    | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    Then No exception was thrown
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then No exception was thrown
    When I change tag name from "Tag1" to "Tag111"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:delete:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Read + Tag:Write permission to user and revoke Tag:Write in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Write permission to user0
  Revoke Tag:Write from user0
  Login as user0 and try to query Tags - no exception should be thrown
  Try to create a tag - it should not be possible without Tag:Write permission
  Try to edit a tag - it should not be possible without Tag:Write permission
  Try to delete a tag - it should not be possible without Tag:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
      | tag    | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:delete:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Read + Tag:Write permission to user and revoke Tag:Read in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Write permission to user0
  Revoke Tag:Read from user0
  Login as user0 and try to query Tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
      | tag    | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Read + Tag:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Delete permission to user0
  Login as user0 and try to query tags - no exception should be thrown
  Try to create a tag - it should not be possible without Tag:Write permission
  Try to edit a tag - it should not be possible without Tag:Write permission
  Try to delete a tag - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
      | tag    | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    When I delete tag with name "Tag2"
    When Tag with name "Tag2" is searched
    Then No tag was found
    Then I logout

  Scenario: Adding Tag:Read + Tag:Delete permission to user and revoke Tag:Delete in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Delete permission to user0
  Revoke Tag:Delete from user0
  Login as user0 and try to query Tags - no exception should be thrown
  Try to create a tag - it should not be possible without Tag:Write permission
  Try to edit a tag - it should not be possible without Tag:Write permission
  Try to delete a tag - it should not be possible without Tag:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
      | tag    | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:delete:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Read + Tag:Delete permission to user and revoke Tag:Read in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Read and Tag:Delete permission to user0
  Revoke Tag:Read from user0
  Login as user0 and try to query Tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | delete |
      | tag    | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:write:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Write + Tag:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Write and Tag:Delete permission to user0
  Login as user0 and try to query tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
      | tag    | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Write + Tag:Delete permission to user and revoke Tag:Delete in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Write and Tag:Delete permission to user0
  Revoke Tag:Delete from user0
  Login as user0 and try to query Tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
      | tag    | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:Write + Tag:Delete permission to user and revoke Tag:Write in same scope
  Login as kapua-sys
  Create a few sample Tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Tag:Write and Tag:Delete permission to user0
  Revoke Tag:Write from user0
  Login as user0 and try to query Tags - it should not be possible without Tag:Read permission
  Try to create a tag - it should not be possible without Tag:Read permission
  Try to edit a tag - it should not be possible without Tag:Read permission
  Try to delete a tag - it should not be possible without Tag:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | write  |
      | tag    | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When Tag with name "Tag1" is searched
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I change tag name from "Tag1" to "Tag111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: tag:read:1:*"
    When I delete tag with name "Tag2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding Tag:All permissions to user in same scope
  Login as kapua-sys
  Create a few sample tags
  Create a sample user in kapua-sys account (e.g. User0)
  Add Account:ALL permission to user0
  Login as user0 and try to query tags - no exception should be thrown
  Try to create a tag - no exception should be thrown
  Try to edit a tag - no exception should be thrown
  Try to delete a tag - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user0 | Kapua User 1 | user1@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And I create a tag with name "Tag1" and description "Tag numero uno"
    And I create a tag with name "Tag2" and description "Tag numero due"
    And Add permissions to the last created user
      | domain | action |
      | tag    | read   |
      | tag    | write  |
      | tag    | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When Tag with name "Tag1" is searched
    Then I find a tag with name "Tag1"
    Then No exception was thrown
    When I create a tag with name "Tag3" and description "Tag numero tre"
    Then No exception was thrown
    When I change tag name from "Tag1" to "Tag111"
    Then No exception was thrown
    When I delete tag with name "Tag2"
    Then No exception was thrown
    When Tag with name "Tag2" is searched
    Then No tag was found
    Then I logout

    # User
  Scenario: Adding User:Read permission to user in same scope
  Login as kapua-sys.
  Create a few users.
  Create a sample user in kapua-sys account (e.g. User0).
  Add User:Read permission to user0.
  Login as user0 and query users - no exception should be thrown.
  Try to create a user - it should not be possible without user:Write permission.
  Try to edit a user - it should not be possible without user:Write permission.
  Try to delete a user - it should not be possible without user:Write permission.

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user1"
    Then I find user
      | name  |
      | user1 |
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    When I search for user with name "user1"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I try to edit user to name "user111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:delete:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking User:Read permission from user in same scope
  Login as kapua-sys
  Create a few Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read permission to user0
  Revoke User:Read permission to user0
  Login as user0 and query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Write permission to user in same scope
  Login as kapua-sys
  Create a few sample user
  Create a sample user in kapua-sys account (e.g. User0)
  Add user:Write permission to user0
  Login as user0 and try to query users, it should not be possible without user:Read permission
  Try to create a user - it should not be possible without user:Read permission
  Try to edit a user - it should not be possible without user:Read permission
  Try to delete user - it should not be possible without user:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "NullPointerException" with the text "*"
    When I try to edit user to name "user111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking User:Write permission from user in same scope
  Login as kapua-sys
  Create a few Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Write permission to user0
  Revoke User:Write permission from user0
  Login as user0 and query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Delete permission to user in same scope
  Login as kapua-sys
  Create a few sample users
  Create a sample user in kapua-sys account (e.g. User0)
  Add user:Delete permission to user0
  Login as user0 and try to query users, it should not be possible without user:Read permission
  Try to create a user - it should not be possible without user:Read permission
  Try to edit a user - it should not be possible without user:Read and user:Read permissions
  Try to delete a user - it should not be possible without user:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Revoking User:Delete permission from user in same scope
  Login as kapua-sys
  Create a few Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Delete permission to user0
  Revoke User:Delete permission to user0
  Login as user0 and query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Write permissions to user in same scope
  Login as kapua-sys
  Create a few sample users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read and User:Write permission to user0
  Login as user0 and try to query users - no exception should be thrown
  Try to create a user - no exception should be thrown
  Try to edit a user - no exception should be thrown
  Try to delete a user - it should not be possible without user:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user2"
    Then No exception was thrown
    When I create user with name "user3"
    Then No exception was thrown
    When I search for user with name "user1"
    When I try to edit user to name "user111"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:delete:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Write permission to user and revoke User:Write in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read and User:Write permission to user0
  Revoke User:Write from user0
  Login as user0 and try to query Users - no exception should be thrown
  Try to create a User - it should not be possible without User:Write permission
  Try to edit a User - it should not be possible without User:Write permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user2"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    When I search for user with name "user1"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I try to edit user to name "user111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:delete:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Write permission to user and revoke User:Read in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read and User:Write permission to user0
  Revoke User:Read from user0
  Login as user0 and query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Write permission
  Try to edit a User - it should not be possible without User:Write permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | write  |
      | user   | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user2"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample users
  Create a sample user in kapua-sys account (e.g. User0)
  Add user:Read and user:Delete permission to user0
  Login as user0 and try to query users - no exception should be thrown
  Try to create a user - it should not be possible without user:Write permission
  Try to edit a user - it should not be possible without user:Write permission
  Try to delete a user - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user2"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    When I search for user with name "user1"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I try to edit user to name "user111"
    Then An exception was thrown
    Then I try to delete user "user2"
    Then No exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Delete permission to user and revoke User:Delete in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read and User:Delete permission to user0
  Revoke User:Delete from user0
  Login as user0 and try to query Users - no exception should be thrown
  Try to create a User - it should not be possible without User:Write permission
  Try to edit a User - it should not be possible without User:Write permission
  Try to delete a User - it should not be possible without User:Delete permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user2"
    Then No exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    When I search for user with name "user1"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:write:1:*"
    When I try to edit user to name "user111"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:delete:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Read + User:Delete permission to user and revoke User:Read in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Read and User:Delete permission to user0
  Revoke User:Read from user0
  Login as user0 and try to query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | delete |
      | user   | read   |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user2"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Write + User:Delete permissions to user in same scope
  Login as kapua-sys
  Create a few sample users
  Create a sample user in kapua-sys account (e.g. User0)
  Add user:Write and user:Delete permission to user0
  Login as user0 and try to query users - it should not be possible without user:Read permission
  Try to create a user - it should not be possible without user:Read permission
  Try to edit a user - it should not be possible without user:Read permission
  Try to delete a user - it should not be possible without user:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | delete |
      | user   | write  |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user1"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Write + User:Delete permission to user and revoke User:Delete in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Write and User:Delete permission to user0
  Revoke User:Delete from user0
  Login as user0 and try to query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | write  |
      | user   | delete |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user2"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:Write + User:Delete permission to user and revoke User:Write in same scope
  Login as kapua-sys
  Create a few sample Users
  Create a sample user in kapua-sys account (e.g. User0)
  Add User:Write and User:Delete permission to user0
  Revoke User:Write from user0
  Login as user0 and try to query Users - it should not be possible without User:Read permission
  Try to create a User - it should not be possible without User:Read permission
  Try to edit a User - it should not be possible without User:Read permission
  Try to delete a User - it should not be possible without User:Read permission

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | delete |
      | user   | write  |
    Then I query for the last permission added to the new User
    And I delete the last permission added to the new User
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I search for user with name "user2"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    When I create user with name "user3"
    Then An exception was thrown
    Given I expect the exception "SubjectUnauthorizedException" with the text "Missing permission: user:read:1:*"
    Then I try to delete user "user2"
    Then An exception was thrown
    Then I logout

  Scenario: Adding User:All permissions to user in same scope
  Login as kapua-sys
  Create a few sample users
  Create a sample user in kapua-sys account (e.g. User0)
  Add Account:ALL permission to user0
  Login as user0 and try to query users - no exception should be thrown
  Try to create a user - no exception should be thrown
  Try to edit a user - no exception should be thrown
  Try to delete a user - no exception should be thrown

    Given I login as user with name "kapua-sys" and password "kapua-password"
    And Scope with ID 1
    And I select account "kapua-sys"
    And A generic user
      | name  | displayName  | email           | phoneNumber     | status  | userType |
      | user1 | Kapua User 1 | user1@kapua.com | +386 31 321 122 | ENABLED | INTERNAL |
      | user2 | Kapua User 2 | user2@kapua.com | +386 31 321 123 | ENABLED | INTERNAL |
      | user0 | Kapua User 0 | user0@kapua.com | +386 31 321 121 | ENABLED | INTERNAL |
    And I add credentials
      | name  | password          | enabled |
      | user2 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user1 | ToManySecrets123# | true    |
    And I add credentials
      | name  | password          | enabled |
      | user0 | ToManySecrets123# | true    |
    And Add permissions to the last created user
      | domain | action |
      | user   | read   |
      | user   | write  |
      | user   | delete |
    Then I logout
    And I login as user with name "user0" and password "ToManySecrets123#"
    When I search for user with name "user2"
    Then No exception was thrown
    When I create user with name "user3"
    Then No exception was thrown
    When I search for user with name "user1"
    When I try to edit user to name "user111"
    Then No exception was thrown
    Then I try to delete user "user2"
    Then No exception was thrown
    Then I logout