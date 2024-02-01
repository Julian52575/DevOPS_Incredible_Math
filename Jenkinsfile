@Library("My_Testing_Library") _

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
        compilationStatus = 84
        csvContent = ""
        githubRepo = "https://github.com/Julian52575/Incredible_Math_Test_Configuration_Files"
        binaryName = "math"
        csvTestName = "Tests.csv"
        csvSetupName = "Setup.csv"
        logName = "Result.log"
        depthName = "Mouli.log"
    }

    stages {
        stage('C] Checkout and stash config files') {
            steps {
                script {
                    
                    git branch: 'Jenkins',
                        credentialsId: params.Credential,
                        url: env.githubRepo
                  
                    stash includes: "*", excludes: "*git*", name: 'configFiles'
                }
            }
        }

        stage('C] Checkout Code') {
            steps {
                //Checkout project
                    git branch: 'main',
                        credentialsId: params.Credential,
                        url: params.Repository

            }
        }

        stage("T] Compilation") {
            steps {
                script {
                    compilationStatus = checkBasics(
                        name: "${env.binaryName}",
                        author: params.Author,
                        logName: "${env.logName}",
                        depthName: "${env.depthName}"
                    )
                    
                    echo "Compilation Status = ${compilationStatus}"
                    stash includes: "${env.logName}", name: 'logFile'
                    stash includes: "${env.depthName}", name: 'depthFile'
                }
            }
        }

        stage("T] Mouli") {
            when {
                expression { compilationStatus == 0 }
            }
            steps {
             
                //Unstashing config and logs files
                unstash 'configFiles'
                unstash 'logFile'
                unstash 'depthFile'

                //Setup
                runSetupFromCSV(
                    CSVname: "${env.csvSetupName}"
                )

                //Starting tests
                printTable(
                    logName: "${env.logName}"
                )
                runTestFromCSV( 
                    CSVname: "${env.csvTestName}",
                    logName: "${env.logName}",
                    depthName: "${env.depthName}"
                )
                printTableEnd(
                    logName: "${env.logName}"
                )
                stash includes: "${env.logName}", name: 'logFile'
                stash includes: "${env.depthName}", name: 'depthFile'
            }
        }
    }
    post {

        always {
            unstash 'logFile'
            unstash 'depthFile'
            sendEmailReport( 
                projectName: params.ProjectName,
                logName: "${env.logName}",
                depthName: "${env.depthName}"
            )

            // Clean after build
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: false)
        }
    }
}
