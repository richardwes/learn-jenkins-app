pipeline {
    agent any

    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:23-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Building the project..."
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'node:23-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    echo "Running tests..."
                    CI=true npm test -- --watchAll=false --runInBand
                    test -f "build/index.html" || (echo "Build failed: index.html not found" && exit 1)
                '''
            }
        }
    }

    post {
        always {
            junit 'test-results/junit.xml'
        }
    }
}
