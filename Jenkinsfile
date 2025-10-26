pipeline {
  agent any
  environment {
    DOCKERHUB = 'anitodevops'       
    REPO = 'react-app'              
    DOCKER_CRED_ID = 'dockerhub-creds'
    SSH_KEY = 'newtestkey.pem'
  }
  triggers {
       githubPush ()
  }
  stages {
    stage('Build Image') {
      steps {
        script {
          def envType = (env.BRANCH_NAME == 'master') ? 'prod' : 'dev'
          def imageFull = "${DOCKERHUB}/${REPO}-${envType}:${env.BUILD_NUMBER}"
          def imageLatest = "${DOCKERHUB}/${REPO}-${envType}:latest"
          sh "docker build -t ${imageFull} ."
          withCredentials([usernamePassword(credentialsId: "${DOCKER_CRED_ID}", usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]){
            sh """
              echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
              docker push ${imageFull}
              docker tag ${imageFull} ${imageLatest}
              docker push ${imageLatest}            
            """
          }
          env.IMAGE_FULL = imageFull
          env.IMAGE_LATEST = imageLatest
        }
      }
    }
    stage('Deploy') {
      steps {
        script {
          def envType = (env.BRANCH_NAME == 'master') ? 'prod' : 'dev'
          def port = (envType == 'prod') ? '80:80' : '8081:80'
	  def container = "app-cont-${envType}"

          sh """
	    ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ubuntu@65.1.148.9 '''
		
		if [ "\$(sudo docker ps -q -f name=${container})" ]; then
                	sudo docker stop ${container}
                	sudo docker rm ${container}
            	elif [ "\$(sudo docker ps -aq -f name=${container})" ]; then
                	sudo docker rm ${container}
            	fi
		sudo docker pull ${IMAGE_LATEST}
            	sudo docker run -d --name ${container} -p ${port} ${IMAGE_LATEST}
	    '''
          """
        }
      }
    }
  }
}
