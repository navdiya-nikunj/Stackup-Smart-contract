// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";

contract Stackup {
    // enum that tracks player's quest status 
    enum playerQuestStatus {
        NOT_JOINED,
        JOINED,
        SUBMITTED
    }
    // enum that tracks quest active status
    enum questStatus {
        OPEN,
        CLOSED,
        DELETED
    }

    // Quest struct which contains quest parameters
    struct Quest {
        uint256 questId;
        uint256 numberOfPlayers;
        string title;
        uint8 reward;
        uint256 numberOfRewards;
        uint256   startTime;     // quest starting time in seconds
        uint256 endTime;         // quest ending time in seconds
        bool deleteFlag;      // delete flag
    }
    address public admin;
    uint256 public nextQuestId;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => playerQuestStatus))
        public playerQuestStatuses;

    constructor() {
        admin = msg.sender;
    }

    // FUnction to create a quest
    function createQuest(
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 endTime_,
        uint256 startTime_
    ) external {
        // only admin can create a quest
        require(msg.sender == admin, "Only the admin can create quests"); 
        quests[nextQuestId].questId = nextQuestId;
        quests[nextQuestId].title = title_;
        quests[nextQuestId].reward = reward_;
        quests[nextQuestId].numberOfRewards = numberOfRewards_;
        quests[nextQuestId].endTime = block.timestamp + endTime_;
        quests[nextQuestId].startTime = block.timestamp+ startTime_;
        quests[nextQuestId].deleteFlag = false;
        nextQuestId++;
    }

    // Function to edit the quest. Admin has to edit all the parameters again and if they don't want to update then leave out the value 0 or leave it empty for string
    function editQuest(uint256 questId,
        string calldata title_,
        uint8 reward_,
        uint256 numberOfRewards_,
        uint256 endTime_,
        uint256 startTime_)external{
            // deleted quests can't be edited
            require(getQuestStatus(questId) != questStatus.DELETED, "QUest is deleted");
            // Only admin can edit the quest
            require(msg.sender == admin,"Only admin can edit the quest");
            require(block.timestamp <= quests[questId].startTime,"You can't update the start time of a started quest. Leave it 0");
            require(block.timestamp <= quests[questId].endTime,"You can't edit the ended quest");
            require(reward_ != 0,"Rewards can't be zero");
            require(numberOfRewards_ != 0,"No of Rewards can't be zero");
            bytes memory tempTitle = bytes(title_);
            require(tempTitle.length != 0,"Title can't be empty");
            quests[questId].title = title_;
            quests[questId].reward = reward_;
            quests[questId].title = title_;
            quests[questId].numberOfRewards = numberOfRewards_;
            quests[questId].endTime = block.timestamp+endTime_;
            if(startTime_ != 0)
                quests[questId].startTime = block.timestamp+startTime_;
        }

        // function to delete the quest
        function deleteQuest(uint256 questId) external{
            // Only admin can delete the quest
            require(msg.sender == admin,"Only admin can delete the quest");
            quests[questId].deleteFlag = true;
        }


    // check weather quest is open, ended or deleted 
    function getQuestStatus(uint256 questId) public view returns (questStatus) {
        if(quests[questId].deleteFlag == true)
            return questStatus.DELETED;
        if (block.timestamp <= (quests[questId].endTime) && block.timestamp >= (quests[questId].startTime) ) {
            return questStatus.OPEN;
        }
        return questStatus.CLOSED;
    }

    // function to join the quest. player can join quest using questid
    function joinQuest(uint256 questId) external questExists(questId) {
        // check if quest is open or close
        require(
            getQuestStatus(questId) != questStatus.CLOSED,
            "Quest is closed"
        );
        // check player already joined the quest
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.NOT_JOINED,
            "Player has already joined/submitted this quest"
        );
        playerQuestStatuses[msg.sender][questId] = playerQuestStatus.JOINED;

        Quest storage thisQuest = quests[questId];
        thisQuest.numberOfPlayers++;
    }


    // function to submit quest. 
    function submitQuest(uint256 questId) external questExists(questId) {
        // check if quest is open or close
        require(
            getQuestStatus(questId) != questStatus.CLOSED,
            "Quest is closed"
        );
        // check if player joined or not
        require(
            playerQuestStatuses[msg.sender][questId] ==
                playerQuestStatus.JOINED,
            "Player must first join the quest"
        );
        
        playerQuestStatuses[msg.sender][questId] = playerQuestStatus.SUBMITTED;
    }

    // check quest exist or not before executing any above functions
    modifier questExists(uint256 questId) {
        require(quests[questId].reward != 0, "Quest does not exist");
        _;
    }
        
}
