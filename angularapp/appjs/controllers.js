(function(){
	
	var resumeControllers = angular.module('resumeControllers', ['resumeServices']);
	
	resumeControllers.controller('CompanyCtrl', ['$scope', 'ResumeRest', function(scope, rest){

		rest.getJobsDictionary(2, function(resume){
			scope.companies = resume.companies;
			scope.personName = resume.personName;
			scope.email = resume.email;
		});
		
		rest.getAllSkillsArray(2, function(skills){
			scope.skills = skills;
		});
		
		rest.getCertificationsArray(2, function(certs) {
			scope.certifications = certs;
			console.log(JSON.stringify(certs));
		});
		
		
	}]);
	
	resumeControllers.directive('companyPanel', function(){
		return {
			scope: {
				companyInfo: '=info'
			},
			templateUrl: '/resume/partials/company-panel.html'
		};
	});
	
})();
