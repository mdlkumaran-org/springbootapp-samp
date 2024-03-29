pipeline {
   agent {
      label "jenkins-slave"
   }

   tools {
      maven 'MAVEN'
      dockerTool 'DOCKER'
   }

   environment {
     // You must set the following environment variables
     // ORGANIZATION_NAME
     // YOUR_DOCKERHUB_USERNAME (it doesn't matter if you don't have one)

     SERVICE_NAME = "springbootapp"
     REPOSITORY_TAG="${YOUR_DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${SERVICE_NAME}:${BUILD_ID}"
   }

   stages {
      stage('Preparation') {
         steps {
            cleanWs()
            git credentialsId: 'GitHub', url: "https://github.com/${ORGANIZATION_NAME}/${SERVICE_NAME}"
         }
      }
      stage('Build') {
         steps {
            sh '''mvn clean package -DskipTests'''
         }
      }

      stage('Build Docker Image') {
         steps {
           sh 'docker image build -t ${REPOSITORY_TAG} .'
         }
      }

      stage('DockerHub Push') {
         steps {
           withDockerRegistry(credentialsId: 'dockerhub_id', url: '') {
               sh 'docker push ${REPOSITORY_TAG}'
            }
         }
      }

      stage('Helm Template') {
         steps {
           sh 'helm template ${WORKSPACE}/helm-chart > ${WORKSPACE}/deploy.yaml'
         }
      }

      // stage('Deploy to Cluster') {
      //     steps {
      //               sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
      //     }
      // }

      stage ('K8S Deploy') {
       steps {
            kubernetesDeploy(
               configs: 'deploy.yaml',
               kubeconfigId: 'K8s',
               enableConfigSubstitution: true
            )       
                   
         }
      }
   }
}