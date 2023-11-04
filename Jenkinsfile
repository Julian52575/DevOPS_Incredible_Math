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
        logName = "New_mouli.log"
        depthName = "InDepth.log"
    }

    stages {
        stage('Checkout and stash config files') {
            steps {
                script {
                    
                    git branch: 'Jenkins',
                        credentialsId: params.Credential,
                        url: env.githubRepo
                  
                    sh 'ls -l'
                    stash includes: "*", excludes: "*git*", name: 'configFiles'
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
                        name: "math",
                        author: params.Author
                        logName: "${env.logName}"
                    )
                }
            }
        }

        stage("Check in-depth") {
            //when {
            //    expression { return env.hasCompiled == 0 }
            //} 
            steps {
                unstash 'configFiles'
                printTable(
                    logName: "${env.logName}"
                )
                runTestFromCSV( 
                    CSVfile: "${env.csvName}"
                    logName: "${env.logName}"
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
                projectName: params.ProjectName
                logName: "${env.logName}"
                depthName: "${env.depthName}"
            )

            // Clean after build
            cleanWs(cleanWhenNotBuilt: true,
                    deleteDirs: true,
                    disableDeferredWipeout: false)
        }
    }
}
