(function(){
	
	var resumeServices = angular.module('resumeServices', []);
	
	resumeServices.factory('ResumeRest', ['$http', function(http){
		var personfields = {id:'personName', data: {'personName': 'personName', 'email': 'email', 'phone': 'phone'}}
		,	companyfields = {id: 'companyName', data: {'companyName': 'companyName', 'companyStartDate': 'startDate', 'companyEndDate': 'endDate'}}
		,	positionfields = {id: 'positionName', data: {'positionName': 'positionName', 'positionStartDate': 'startDate', 'positionEndDate': 'endDate'}};
		
		function populate(row, dict, fields){
			var from, to, data = fields.data;
			
			if (dict[row[fields.id]] == null){
				dict[row[fields.id]] = {};
				
				for (from in data) {
					to = data[from];
					dict[row[fields.id]][to] = row[from];
				}
			}
			
		}
		
		function flatten(dict){
			var arr = []
			,	key;
			
			for (key in dict) {
				arr.push(dict[key]);
			}
			
			return arr;
		}
		
		function formatCerts(response) {
			var i, row;
			
			for (i=0; i < response.length; i++) {
				row = response[i];
				row.dateReceived = formatDateTime(row.dateReceived);
			}
			
			return response;
		}
		
		function formatDateTime(dt){
			if (dt == '') return 'Present';
			
			var temp = dt.split(' ')[0].split('-')
			,	months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
			,	year = temp[0];
			
			console.log('temp: ' + temp);

			return months[parseInt(temp[1]) -1] + " '" + year;
		}
		
		function formatJobs(response) {
			var resume = {}
			,	i, row, current;
			
			resume.personName = response[0]['personName'];
			resume.email = response[0]['email'];
			resume.phone = response[0]['phone'];
			
			for(i=0; i < response.length; i++){
				row = response[i];
				
				resume.companies = resume.companies || {};
				populate(row, resume.companies, companyfields);

				current = resume.companies[row['companyName']];
				current.positions = current.positions || {};
				populate(row, current.positions, positionfields);
				
				current = current.positions[row['positionName']];
				current.responsibilities = current.responsibilities || [];
				current.responsibilities.push(row['responsibilityDescription']);
			}
			
			
			resume.companies = flatten(resume.companies);
			
			for(i=0; i < resume.companies.length; i++) {
				resume.companies[i].positions = flatten(resume.companies[i].positions);
				resume.companies[i].startDate = formatDateTime(resume.companies[i].startDate);
				resume.companies[i].endDate = formatDateTime(resume.companies[i].endDate);
				
				for(j=0; j < resume.companies[i].positions.length; j++){
					resume.companies[i].positions[j].startDate = formatDateTime(resume.companies[i].positions[j].startDate);
					resume.companies[i].positions[j].endDate = formatDateTime(resume.companies[i].positions[j].endDate);
				}
			}
			
			return resume;

		}
		
		
		
		function uniqueSkillsArray(response) {
			var dict = {}, skills = [], key, value;
			
			for (key in response) {
				value = response[key];
				if (!dict[value.skillname]) {
					dict[value.skillname] = true;
					skills.push(value.skillname);
				}
			}
			
			skills.sort();
			
			return skills;
		}
		
		function curry(callback, format) {
			return function(data) {
				if (callback != null) callback(format(data));
			};
		}
		
		function get(url) {
			return {
				method: 'GET',
				url: url
			};
		}
		
		return {
			getAllSkillsArray: function(personId, success, error){
				http(get('/resume/restapi/skills.php?pid=' + personId)
				).success( curry(success, uniqueSkillsArray)
				).error( (error == null) ? function(){} : error );
			},
			getJobsDictionary: function(personId, success, error){
				http(get('/resume/restapi/jobs.php?pid=' + personId)	
				).success( curry(success, formatJobs)
				).error( (error == null) ? function(){} : error );
			},
			getCertificationsArray: function(personId, success, error){
				http( get('/resume/restapi/certifications.php?pid=' + personId)
				).success( curry(success, formatCerts) 
				).error( (error == null) ? function(){} : error );
			} 
			
		};
		
	}]);
	
})();
