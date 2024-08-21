// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TeacherPerformanceRewards {

    // Struct to represent a teacher
    struct Teacher {
        address teacherAddress;
        uint performanceScore;
        uint rewards;
    }

    // Array to store the list of teacher addresses
    address[] public teacherAddresses;

    // Mapping from teacher address to Teacher struct
    mapping(address => Teacher) public teachers;

    // Mapping to track rewards distributed to each teacher
    mapping(address => uint) public rewardsDistributed;

    // Owner of the contract (could be the school or educational institution)
    address public owner;

    // Event to be emitted when rewards are distributed
    event RewardDistributed(address indexed teacher, uint amount);

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new teacher
    function addTeacher(address _teacherAddress) public onlyOwner {
        require(teachers[_teacherAddress].teacherAddress == address(0), "Teacher already exists");
        teachers[_teacherAddress] = Teacher(_teacherAddress, 0, 0);
        teacherAddresses.push(_teacherAddress);
    }

    // Function to fund the contract
    function fundContract() public payable onlyOwner {}

    // Function to update a teacher's performance score
    function updatePerformanceScore(address _teacherAddress, uint _performanceScore) public onlyOwner {
        require(teachers[_teacherAddress].teacherAddress != address(0), "Teacher does not exist");
        teachers[_teacherAddress].performanceScore = _performanceScore;
    }

    // Function to distribute rewards to teachers based on performance
    function distributeRewards() public onlyOwner {
        for (uint i = 0; i < teacherAddresses.length; i++) {
            address teacherAddress = teacherAddresses[i];
            Teacher storage teacher = teachers[teacherAddress];
            uint reward = calculateReward(teacher.performanceScore);
            teacher.rewards += reward;
            rewardsDistributed[teacher.teacherAddress] += reward;
            payable(teacher.teacherAddress).transfer(reward);
            emit RewardDistributed(teacher.teacherAddress, reward);
        }
    }

    // Function to calculate reward based on performance score
    function calculateReward(uint _performanceScore) internal pure returns (uint) {
        // Send 0.0009 ether per performance point
        return _performanceScore * 0.0009 ether;
    }

    // Function to get the number of teachers
    function getNumberOfTeachers() public view returns (uint) {
        return teacherAddresses.length;
    }

    // Function to view the total rewards distributed to a specific teacher
    function getRewardsDistributed(address _teacherAddress) public view returns (uint) {
        return rewardsDistributed[_teacherAddress];
    }
}
