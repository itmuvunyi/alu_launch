public class DNSCheck {
    public static void main(String[] args) throws Exception {
        System.out.println("Google:");
        System.out.println(java.net.InetAddress.getByName("google.com"));

        System.out.println("Maven:");
        System.out.println(java.net.InetAddress.getByName("repo.maven.apache.org"));

        System.out.println("Gradle:");
        System.out.println(java.net.InetAddress.getByName("plugins.gradle.org"));

        System.out.println("Gradle Artifacts:");
        System.out.println(java.net.InetAddress.getByName("plugins-artifacts.gradle.org"));
    }
}