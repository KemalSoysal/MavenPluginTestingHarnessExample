#!/bin/bash
groupId=org.apache.maven.plugin.my
artifactId=my-maven-plugin

cat <<ParentPom > pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>$groupId</groupId>
  <artifactId>$artifactId-parent</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>pom</packaging>
  <name>Test MyMojo Parent</name>

  <properties>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
  </properties>

</project>
ParentPom

mvn \
  -DgroupId=$groupId \
  -DartifactId=$artifactId \
  -Dpackage=$groupId \
  -DinteractiveMode=false \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-plugin \
  -DarchetypeVersion=1.4 archetype:generate

sed -i.bkp  -e '/<dependencies>/r harnessDependency.xml' $artifactId/pom.xml

mkdir -p $artifactId/src/test/java/org/apache/maven/plugin/my 
cat <<MyMojoTest > $artifactId/src/test/java/org/apache/maven/plugin/my/MyMojoTest.java
package org.apache.maven.plugin.my;

import java.io.File;
import org.apache.maven.plugin.testing.AbstractMojoTestCase;

public class MyMojoTest
    extends AbstractMojoTestCase
{
    /** {@inheritDoc} */
    protected void setUp()
        throws Exception
    {
        // required
        super.setUp();
    }

    /** {@inheritDoc} */
    protected void tearDown()
        throws Exception
    {
        // required
        super.tearDown();
    }

    /**
     * @throws Exception if any
     */
    public void testSomething()
        throws Exception
    {
        File pom = getTestFile( "src/test/resources/unit/project-to-test/pom.xml" );
        assertNotNull( pom );
        assertTrue( pom.exists() );

        MyMojo myMojo = (MyMojo) lookupMojo( "touch", pom );
        assertNotNull( myMojo );
        myMojo.execute();
    }
    
    /**
     * @throws Exception if any
     */
    public void testSomethingSimple()
        throws Exception
    {
      MyMojo myMojo = new MyMojo();
      Object outputDirectory = getVariableValueFromObject(myMojo, "outputDirectory");
      assertNull(String.format("outputDirectory should have not been initialized",outputDirectory), outputDirectory );
      setVariableValueToObject(myMojo, "outputDirectory", new File("target"));
      outputDirectory = getVariableValueFromObject(myMojo, "outputDirectory");
      assertNotNull( outputDirectory );
      assertEquals(String.format("outputDirectory should have been set to %s",outputDirectory), getVariableValueFromObject(myMojo, "outputDirectory"), outputDirectory);
    }
}
MyMojoTest

mkdir -p $artifactId/src/test/resources/unit/project-to-test
cat <<ProjectToTest >$artifactId/src/test/resources/unit/project-to-test/pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>org.apache.maven.plugin.my.unit</groupId>
  <artifactId>project-to-test</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>jar</packaging>
  <name>Test MyMojo</name>

  <properties>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
  </properties>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <artifactId>my-maven-plugin</artifactId>
        <configuration>
          <!-- Specify the MyMojo parameter -->
          <outputDirectory>target/test-harness/project-to-test</outputDirectory>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
ProjectToTest
