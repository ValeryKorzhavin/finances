pipeline {
  agent none
  options {
    skipStagesAfterUnstable()
    skipDefaultCheckout()
  }
  environment {
    IMAGE_BASE = 'docker893'
    IMAGE_TAG = "v$BUILD_NUMBER"
    IMAGE_NAME = "${env.IMAGE_BASE}"
    IMAGE_NAME_LATEST = "${env.IMAGE_BASE}:latest"
    DOCKERFILE_NAME = "Dockerfile"
  }

  stages {
    stage("Prepare container") {
      agent {
        docker {
          image 'openjdk:11.0.5-slim'
        }
      }
      stages {
        stage('Build') {
          steps {
            checkout scm
            sh './mvnw compile'
          }
        }
        stage('Test') {
          steps {
            sh './mvnw test'
            junit '**/target/surefire-reports/TEST-*.xml'
          }
        }
        stage('Package') {
          steps {
            sh './mvnw package -DskipTests'
          }
        }
      }
    }

    stage('Push images') {
        agent any
        when {
            branch 'master'
        }
        steps {
            script {
                def dockerImage1 = docker.build("${env.IMAGE_NAME}/registry:${env.IMAGE_TAG}", "-f registry/${env.DOCKERFILE_NAME} $WORKSPACE/registry")
                def dockerImage2 = docker.build("${env.IMAGE_NAME}/gateway:${env.IMAGE_TAG}", "-f gateway/${env.DOCKERFILE_NAME} $WORKSPACE/gateway")

                docker.withRegistry('', 'dockerhub-creds') {
                    dockerImage1.push()
                    dockerImage2.push()
                    dockerImage1.push("latest")
                    dockerImage2.push("latest")

                }
            }
            sh "docker rmi ${env.IMAGE_NAME}/registry:${env.IMAGE_TAG} docker893/registry:latest"
            sh "docker rmi ${env.IMAGE_NAME}/gateway:${env.IMAGE_TAG} docker893/gateway:latest"

        }
    }

    stage('Deploy to GKE') {
        agent {
            docker {
                image 'dtzar/helm-kubectl:3.3.1'
            }
        }
        when {
            branch 'master'
        }
        steps {
            withKubeConfig([credentialsId: 'kubernetes-creds', serverUrl: "${CLUSTER_URL}", namespace: "${CLUSTER_NAMESPACE}"]) {
                sh "helm upgrade ${HELM_PROJECT} helm-charts/${HELM_CHART} --reuse-values --set registry.image.tag=${env.IMAGE_TAG} --set gateway.image.tag=${env.IMAGE_TAG}"
            }
        }
    }

  }
}