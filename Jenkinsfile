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
        githubRepo = "https://github.com/Julian52575/Incredible_Math_Test_Configuration_Files"
        csvName = "NMtests.csv"
    }

    stages {
        stage('Checkout and stash CSV') {
            steps {
                script {
                    
                    git branch: 'Jenkins',
                        credentialsId: params.Credential,
                        url: env.githubRepo
                  
                    sh 'ls -l'
                    stash includes: "${env.csvName}", name: 'csvFile'
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
                unstash 'csvFile'
                printTable()
                runTestFromCSV()
                printTableEnd()
                sh 'ls'
            }
        }
    }
    post {

        success {
            sh 'ls'
            sh 'cat new_mouli_log.txt'
            sendEmailReport( projectName:params.ProjectName )
        }

        always {            
            // Clean after build
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: false)
        }
    }
}
