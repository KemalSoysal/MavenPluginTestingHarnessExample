# maven-plugin-testing-harness Example
Using maven-plugin-testing-harness bases on an old documentation. I could not find 
satisfactory dependencies to accomplish my task.
Therefore I created this example project.

## createProject.sh
It creates
* a main pom
* a maven plugin from the plugin-archetype.
* the missing test dependency to 
  ```
    <dependency>
      <groupId>org.eclipse.sisu</groupId>
      <artifactId>org.eclipse.sisu.plexus</artifactId>
      <version>0.3.4</version>
      <scope>test</scope>
    </dependency>
  ```
* the test class
* the test pom

## Building

```
./createProject.sh
mvn test
```