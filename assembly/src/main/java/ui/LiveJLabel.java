package ui;
import javax.accessibility.AccessibleContext;
import javax.accessibility.AccessibleRole;
import javax.swing.JLabel;

public class LiveJLabel extends JLabel {
    public LiveJLabel(String text, int horizontalAlignment) {
        super(text, horizontalAlignment);
    }
    
    @Override
    public AccessibleContext getAccessibleContext() {
        if (accessibleContext == null) {
            accessibleContext = new AccessibleJLabel() {
                @Override
                public AccessibleRole getAccessibleRole() {
                    return AccessibleRole.ALERT;
                }
            };
        }
        return accessibleContext;
    }
}