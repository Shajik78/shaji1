
node {
    def app
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        checkout scm
    }
stage('Build image')  {
  checkout scm
  sh "docker build -t  shaji1 ."
}
  stage('Push image') {
       docker.withRegistry('765421969562.dkr.ecr.us-east-1.amazonaws.com/shaji1', 'ecr:us-east-1:shaji') {
    docker.image('shaji1').push('latest')
        }
    }
}
/* end of build  */
