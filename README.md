# Stackup Smart Contract - Enhancements

The Stackup smart contract provided [here](https://app.stackup.dev/tutorial/creating-a-stackup-smart-contract), developed using Solidity, has been enriched with two additional features, augmenting its functionality. This document delves into the rationale behind selecting these features and provides a comprehensive explanation of their workings.

## 1. Edit and Delete Quests - Admin Privileges for Quest Management

### Rationale

The ability to modify and remove quest details is paramount. Admins should possess the authority to edit quest information as well as delete quests if necessary. Only admins hold the privilege to execute these actions, ensuring the integrity and control of the quest system.

### Implementation

To facilitate quest editing, a new function called `editQuest` has been introduced. This function accepts all the relevant quest parameters, enabling comprehensive modification of quest details. Within the function's logic, the quest details are updated based on the provided `questID`.

The `editQuest` function adheres to the following requirements:

- Only admin accounts are eligible to utilize this function.
- The start time of an ongoing quest cannot be altered by the admin.
- The admin cannot edit a quest that has already concluded.
- Editing a quest that has been deleted is prohibited.
- The number of rewards and their associated details cannot be set to zero.
- The title of a quest cannot be left empty.

Additionally, a delete flag has been incorporated into the Quest struct. When this flag is set to true, the quest is considered deleted. The `deleteQuest` function has been introduced to facilitate this deletion process. It adjusts the delete flag based on the provided `questID`.

The `deleteQuest` function necessitates the following requirements:

- Only admin accounts are authorized to invoke this function.

## 2. Quest Start and End Times - Time Management for Quests

### Rationale

To ensure efficient quest management for both users and admins, each quest has been endowed with start and end times. By incorporating these timestamps, users can be prevented from joining quests that have already concluded, optimizing the quest experience.

### Implementation

Two additional parameters, `startTime` and `endTime`, have been added to the Quest struct. These parameters store the corresponding time values when the `createQuest` function is invoked. Both `startTime` and `endTime` are measured in seconds, enabling precise time tracking.

An enum has been created to represent three distinct states of a quest:

- OPEN: Signifies that the quest is currently available for participation.
- CLOSED: Indicates that the quest has concluded and is not available for participation.
- DELETED: Reflects that the quest has been deleted and is no longer accessible.

To determine the quest status, a function called `getQuestStatus` has been implemented. This function examines the delete flag to determine if the quest has been deleted. Furthermore, the `joinQuest` function has been modified to allow players to join only open quests, thus preserving the integrity of the quest system.

These enhancements to the Stackup smart contract empower admins with the ability to manage quests efficiently, ensuring the timely editing, deletion, and time-based availability of quests for users.
