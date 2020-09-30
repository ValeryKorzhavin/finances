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

                docker.withRegistry('', 'dockerhub-creds') {
                    dockerImage1.push()

                    dockerImage1.push("latest")

                }
            }
            sh "docker rmi ${env.IMAGE_NAME}/registry:${env.IMAGE_TAG} docker893/registry:latest"
            
        }
    }

    stage('Deploy to GKE') {
        agent {
            docker {
                image 'alpine/helm:2.14.0'
                args 'entrypoint=/bin/bash'
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