resource "kubernetes_namespace" "Assessment" {
  metadata {
    name = "web"
  }
}
resource "kubernetes_deployment" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.Assessment.metadata.0.name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "WebApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "WebApp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "web-nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.Assessment.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.Assessment.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}