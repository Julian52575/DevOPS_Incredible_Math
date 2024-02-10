@Library("My_Testing_Library") _

pipeline {

  agent any

    parameters {
        credentials(name: 'Credential')
        string(name: 'Repository', defaultValue: 'https://github.com/Julian52575/Incredible_Math')
        string(name: 'Email', defaultValue: 'julian.bottiglione@epitech.eu', description: 'the email that will receive the log')
    }

    environment {
        binaryName = "math"
        githubRepo = "https://github.com/Julian52575/Incredible_Math_Test_Configuration_Files"
        compilationStatus = 84
        csvContent = ""
        csvTestName = "Tests.csv"
        csvSetupName = "Setup.csv"
        logPath = "Result.log"
    }

    stages {
        stage('Checkout and stash config files') {
            steps {
                script {
                    
                    git branch: 'Jenkins',
                        credentialsId: params.Credential,
                        url: env.githubRepo
                  
                    stash includes: "*", excludes: "*git*", name: 'configFiles'

                    sh "touch ${env.logPath}"
                    sh 'ls'
                    stash includes: "${env.logPath}", name: 'logFile'
                }
            }
        }

        stage('Checkout Code') {
            steps {
                //Checkout project
                    git branch: 'main',
                        credentialsId: params.Credential,
                        url: params.Repository

            }
        }

        stage("@-Compilation") {
            steps {
                script {
                    printHeader(
                        name: "${env.binaryName}",
                        logName: "${env.logPath}"
                    )
                    compilationStatus = checkBasics(
                        name: "${env.binaryName}",
                        author: params.Author,
                        logName: "${env.logPath}"
                    )
                    
                    echo "Compilation Status = ${compilationStatus}"
                    stash includes: "${env.logPath}", name: 'logFile'
                }
            }
        }

        stage("@-Mouli") {
            when {
                expression { compilationStatus == 0 }
            }
            steps {
             
                //Unstashing config and logs files
                unstash 'configFiles'
                unstash 'logFile'

                //Setup
                runSetupFromCSV(
                    CSVpath: "${env.csvSetupName}"
                )

                //Starting tests
                printTable(
                    logName: "${env.logPath}"
                )
                runTestFromCSV( 
                    CSVpath: "${env.csvTestName}",
                    logName: "${env.logPath}"
                )
                printTableEnd(
                    logName: "${env.logPath}"
                )
                stash includes: "${env.logPath}", name: 'logFile'
            }
        }
    }
    post {

        always {
            unstash 'logFile'
            sendEmailReport( 
                projectName: params.ProjectName,
                receiverEmailAddress: params.Email,
                logPath: "${env.logPath}"
            )

            // Clean after build
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: false)
        }
    }
}
