import io.appium.java_client.AppiumDriver;
import io.appium.java_client.MobileElement;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.testng.annotations.*;

public class AppiumTest141 {
    private AppiumDriver<MobileElement> driver;

    @BeforeClass
    public void setUp() throws Exception {
        DesiredCapabilities caps = new DesiredCapabilities();
        caps.setCapability("platformName", "Android");
        caps.setCapability("deviceName", "emulator-5554");
        caps.setCapability("app", System.getenv("APK_PATH"));
        driver = new AppiumDriver<>(new java.net.URL("http://localhost:4723/wd/hub"), caps);
    }

    @Test
    public void test141() {
        // TODO: add real steps for test 141
        // Example: driver.findElementById("com.example:id/button").click();
        assert true;
    }

    @AfterClass
    public void tearDown() {
        if (driver != null) driver.quit();
    }
}
