
pipeline {
    agent any

    environment {
        APP_NAME = 'pdf-navigator'
        APP_PORT = '8088'
        COMPOSE_PROJECT_NAME = 'pdf-navigator'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Validate Project') {
            steps {
                sh '''
                    set -eu

                    test -f manifest.json
                    test -f popup.html
                    test -f popup.css
                    test -f popup.js
                    test -f Dockerfile
                    test -f docker-compose.yml
                    test -f nginx/default.conf

                    python3 -m json.tool manifest.json > /dev/null

                    echo "Project validation successful."
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -eu
                    docker compose build
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                    set -eu
                    docker compose up -d --remove-orphans
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    set -eu

                    ATTEMPTS=15

                    for i in $(seq 1 "$ATTEMPTS"); do
                        if curl -fsS "http://127.0.0.1:${APP_PORT}/health"; then
                            echo ""
                            echo "Health check successful."
                            break
                        fi

                        if [ "$i" -eq "$ATTEMPTS" ]; then
                            echo "Health check failed."
                            docker compose ps
                            docker compose logs --tail=100
                            exit 1
                        fi

                        sleep 2
                    done

                    curl -fsS \
                        "http://127.0.0.1:${APP_PORT}/popup.html" \
                        -o /dev/null

                    echo "PDF Navigator deployed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
            echo 'Application URL: http://18.209.107.19:8088/'
        }

        failure {
            echo 'Deployment failed. Check the Jenkins Console Output.'
        }
    }
}

