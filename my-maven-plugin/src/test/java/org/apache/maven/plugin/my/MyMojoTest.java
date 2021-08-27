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
      File newFile = new File("target");
      setVariableValueToObject(myMojo, "outputDirectory", newFile);
      outputDirectory = getVariableValueFromObject(myMojo, "outputDirectory");
      assertNotNull( outputDirectory );
      assertEquals(String.format("outputDirectory should have been set to %s", newFile), newFile, getVariableValueFromObject(myMojo, "outputDirectory"));
    }
}
