@Library("CompilationLibrary") _
pipeline {
    agent any

    parameters {
        string(name: 'Repository', defaultValue: 'https://github.com/Julian52575/Incredible_Math')
        credentials(name: 'Credential')
        string(name: 'ProjectName', defaultValue: 'Incredible Math')
        string(name: 'Author', defaultValue: 'Julian Bottiglione', description: 'he who started it all')
        string(name: 'Email', defaultValue: 'julian.bottiglione@epitech.eu', description: 'the email that will receive the log')
    }

    environment {
        hasCompiled = 0
        csvContent = ""
    }

    stages {
        stage('Stash CSV') {
            steps {
                script {
                    env.csvContent = sh (
                        script: 'cat ./JenkinsNewMouli.csv',
                        returnStdout: true
                    )
                }
            }
        }

        stage('Checkout Code') {
            steps {
                //Checkout project
                    git branch: 'main',
                        credentialsId: params.Credential,
                        url: params.Repository

                    sh "ls -lat"
            }
        }

        stage("Check Basics") {
            steps {
                script {
                    env.hasCompiled = checkBasics(
                        name:"math",
                        author:params.Author
                    )
                }
            }
        }

        stage("Check in-depth") {
            //when {
            //    expression { return env.hasCompiled == 0 }
            //} 
            steps {
                printTable()
                sh "cat ${env.csvContent} >> JenkinsNewMouli.csv"
                runTestFromCSV()
                printTableEnd()
            }
        }
    }
    post {
        always {
            sendEmailReport( projectName:params.ProjectName )
            
            // Clean after build
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: false)
        }
    }
}
