/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ece356Types;

import java.text.SimpleDateFormat;
import java.util.Date;
/**
 *
 * @author liyuanqi
 */
public class PatientSearchResult {
    public String alias;
    public String home_address;
    public int review_count;
    public Date last_review;
    public String link;
    
    public String GetLastReviewDate()
    {
        String output;
        SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
        if(last_review == null)
            output = "NONE";
        else
            output = dateformat.format(this.last_review);
        
        return output;
    }
}
