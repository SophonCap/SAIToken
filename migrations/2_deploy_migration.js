var SAIToken = artifacts.require("./SAIToken.sol");
var SAIDistribution= artifacts.require("./SAIDistribution.sol");

module.exports =function(deployer){
	var SAITokenInstance, DistInstance;
	deployer.then(function(){
		return SAIToken.new("0xb9d496Fc184FCDc80f3F2DD8c4dDb46e75134de3",
			"0x1e14AE9F80DA8c68EA67bA717B6A751D4eA22CA7",
			"0x85d4f432524FA70ed2F2eba01B7d034b85584Cca");
	}).then(function(instance){
		SAITokenInstance = instance;
		console.log("SAIToken Add: "+ instance.address);
		return SAIDistribution.new(instance.address);
	}).then(function(instance){
		DistInstance = instance;
		console.log("SAIDistribution Add: "+ instance.address);
		return SAITokenInstance.transferOwnership(DistInstance.address);
	}).then(function(success){
		console.log(success);
	}).catch(function(err){
		console.log(err);
	});
}