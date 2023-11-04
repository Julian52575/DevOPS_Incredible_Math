@Library("CompilationLibrary") _
pipeline {

  agent {
    dockerContainer {
      image 'epitechcontent/epitest-docker'
      //args '-d -p 80:80 /usr/sbin/apache2ctl -D FOREGROUND'
    }
  }

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
        binaryName = "math"
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
                        name: "${env.binaryName}",
                        author: params.Author,
                        logName: "${env.logName}",
                        depthName: "${env.depthName}"
                    )
                    stash includes: "${env.logName}", name: 'logFile'
                    stash includes: "${env.depthName}", name: 'depthFile'
                }
            }
        }

        stage("Check CMDs") {
            //when {
            //    expression { return env.hasCompiled == 0 }
            //} 
            steps {
             
                //Unstashing config and logs files
                unstash 'configFiles'
                unstash 'logFile'
                unstash 'depthFile'

                //Starting tests
                printTable(
                    logName: "${env.logName}"
                )
                runTestFromCSV( 
                    CSVname: "${env.csvName}",
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
