pipeline {
  agent any
  environment {
    DOCKERHUB = 'anitodevops'       
    REPO = 'react-app'              
    DOCKER_CRED_ID = 'dockerhub-creds'
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
            if [ "\$(docker ps -q -f name=${container})" ]; then
                docker stop ${container}
                docker rm ${container}
            elif [ "\$(docker ps -aq -f name=${container})" ]; then
                docker rm ${container}
            fi
            docker run -d --name ${container} -p ${port} ${IMAGE_LATEST}
          """
        }
      }
    }
  }
}
