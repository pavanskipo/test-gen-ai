pipeline {
    agent any
    
    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Git branch to build')
        choice(name: 'BUILD_TYPE', choices: ['development', 'staging', 'production'], description: 'Build environment type')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run tests before building')
        booleanParam(name: 'PUSH_IMAGE', defaultValue: true, description: 'Push Docker image to registry')
    }
    
    environment {
        // Define environment variables
        APP_NAME = 'my-application'
        DOCKER_IMAGE = "my-registry/${APP_NAME}:${BUILD_NUMBER}"
        BUILD_ENV = "${params.BUILD_TYPE}"
        NODE_ENV = "${params.BUILD_TYPE}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository from GitHub
                checkout([$class: 'GitSCM', 
                    branches: [[name: "*/${params.BRANCH_NAME}"]], 
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CleanBeforeCheckout']],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/pavanskipo/test-gen-ai']]
                ])
            }
        }
  
        stage('Install Dependencies') {
            steps {
                // Install dependencies directly
                sh 'npm ci'
            }
        }
        
        stage('Build Application') {
            steps {
                // Build the application with environment variable
                sh "NODE_ENV=${NODE_ENV} npm run build"
            }
        }
        
        stage('Run Tests') {
            when {
                expression { params.RUN_TESTS == true }
            }
            steps {
                // Run tests directly
                sh 'npm run test'
            }
        }
        
        stage('Run Linting') {
            steps {
                // Run linting checks
                sh 'npm run lint || true'  // Continue even if linting fails
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Build Docker image using the Dockerfile in the repository
                sh "docker build -t ${DOCKER_IMAGE} --build-arg ENV=${BUILD_ENV} ."
            }
        }
        
        stage('Push Docker Image') {
            when {
                expression { params.PUSH_IMAGE == true }
            }
            steps {
                // Push the Docker image to a registry
                withCredentials([string(credentialsId: 'docker-registry-credentials', variable: 'DOCKER_CREDS')]) {
                    sh 'echo ${DOCKER_CREDS} | docker login -u username --password-stdin my-registry'
                    sh "docker push ${DOCKER_IMAGE}"
                    
                    // Also tag and push as latest if on main branch
                    script {
                        if (params.BRANCH_NAME == 'main') {
                            sh "docker tag ${DOCKER_IMAGE} my-registry/${APP_NAME}:latest"
                            sh "docker push my-registry/${APP_NAME}:latest"
                        }
                    }
                }
            }
        }
        
        stage('Clean Up') {
            steps {
                // Clean up artifacts
                sh 'rm -rf dist node_modules/.cache || true'
            }
        }
    }
    
    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
