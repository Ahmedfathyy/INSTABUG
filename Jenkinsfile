pipeline{
    agent any
    // tools {
    //     go 'Go-v1.18.2'
    // }
    environment {
        DOCKER_IMAGE = "ahmedfathyy/goviolin"
        DOCKER_TAG = "latest"
        GO114MODULE = 'on'
        REPORT_EMAIL = "ahmed.fathy.elayaat@gmail.com"
        GOPATH = "${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_ID}"
        }

    stages {

      stage('Docker Build') {
         steps {
            sh 'docker images -a'
            sh """
             
               docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
               docker images -a
               
            """
         }
      }

        stage ('Run Go tests') {
            steps{
                echo "============Running go tests==========="
                withEnv(["PATH+GO=${GOPATH}/bin"]) {
                    sh """
                        go mod tidy 
                        go test  ./...
                    """     
                }
                }
            post {
                success {
                    echo "Tests passed"
                }
                failure {
                    echo "Tests failed"
                }

            }
        }

      stage ('Push Docker image'){

            steps{
                echo "============Pushing Docker image==========="
             withCredentials([usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])
                {
                sh """
                    docker login -u ${USERNAME} -p ${PASSWORD}
                    docker push  $DOCKER_IMAGE:$DOCKER_TAG
                    """ 
                }
            }
            post {
                success {
                    echo "Docker image pushed successfully"
                }
                failure {
                    echo "Failed to push the image"
                }

            }
            
        }

        
    }

    post {
        success {
            echo "Pipeline completed successfully"
            mail to: $REPORT_EMAIL,
            subject: "GoViolin Pipeline",
            body: "Pipeline completed successfully"
        }
        failure {
            echo "Pipeline failed"
            mail to: $REPORT_EMAIL,
            subject: "GoViolin Pipeline",
            body: "Pipeline failed ... Please Check logs"
        }

    }
}