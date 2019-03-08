def label = "docker-slave-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
    containerTemplate(name: 'docker', image: 'durgaprasad444/jenmine:1.1', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.8.8', ttyEnabled: true, command: 'cat')
],
volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
    node(label) {
        def APP_NAME = "hello-world"
        def tag = "dev"
        environment {
        registry = "durgaprasad444/hello-world-dev"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
            stage("clone code") {
                container('docker') {
                    
                    // Let's clone the source
                    sh """ 
                      git clone https://github.com/durgaprasad444/${APP_NAME}.git            
                      cd ${APP_NAME}
                      cp -r * /home/jenkins/workspace/ci-cd
                    """
                }
            }
        stage("mvn build") {
            container('docker') {
                    // If you are using Windows then you should use "bat" step
                    // Since unit testing is out of the scope we skip them
                    sh "mvn package -DskipTests=true"
            }
        }
        stage('Building image') {
            container('docker') {
              withCredentials([[$class: 'UsernamePasswordMultiBinding',
                credentialsId: 'dockerhub',
                usernameVariable: 'DOCKER_HUB_USER',
                passwordVariable: 'DOCKER_HUB_PASSWORD']]) {
                sh """
                  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD}
                  docker build -t ${DOCKER_HUB_USER}/${APP_NAME}-${tag}:$BUILD_NUMBER .
                  sudo docker push ${DOCKER_HUB_USER}/${APP_NAME}-${tag}:$BUILD_NUMBER
                  """
                }
            
          }
        }
        
        stage("publish to nexus") {
            container('docker') {
def pom = readMavenPom file: 'pom.xml'
 nexusPublisher nexusInstanceId: 'localNexus', \
  nexusRepositoryId: 'hello-world', \
  packages: [[$class: 'MavenPackage', \
  mavenAssetList: [[classifier: '', extension: '', \
  filePath: "target/${pom.artifactId}-${pom.version}.${pom.packaging}"]], \
  mavenCoordinate: [artifactId: "${pom.artifactId}", \
  groupId: "${pom.groupId}", \
  packaging: "${pom.packaging}", \
  version: "${pom.version}"]]]
}
        }
        stage("deploy on kubernetes") {
            container('kubectl') {
                sh "kubectl set image deployment/hello-kubernetes hello-kubernetes=durgaprasad444/${APP_NAME}-${tag}:$BUILD_NUMBER"
            }
        }
                }
            }
        
    
    



   
