library(shiny)
library(shinyAce)


shinyUI(bootstrapPage(


    headerPanel("Cluster Analysis"),


########## Adding loading message #########

tags$head(tags$style(type="text/css", "
#loadmessage {
position: fixed;
top: 0px;
left: 0px;
width: 100%;
padding: 10px 0px 10px 0px;
text-align: center;
font-weight: bold;
font-size: 100%;
color: #000000;
background-color: #CCFF66;
z-index: 105;
}
")),

conditionalPanel(condition="$('html').hasClass('shiny-busy')",
tags$div("Loading...",id="loadmessage")),

#-----------------------------------------#

    sidebarPanel(

    strong("Scores:"),

    checkboxInput("stdz", label = strong("Standardized"), value = T),

    br(),

    radioButtons("type", strong("Clustering:"),
            list("Cases" = "case",
                 "Variables" = "variable"), selected = "case"),

    br(),

    radioButtons("linkage", strong("Linkage method:"),
        list("ward" = "ward", "single" = "single", "complete" = "complete", "average" = "average",
             "mcquitty" = "mcquitty", "median" = "median", "centroid" = "centroid"), selected = "ward"),

    br(),

    radioButtons("distancce", strong("Distance measure:"),
        list("squared euclidean" = "squared.euclidean", "euclidean"="euclidean", "maximum"="maximum",
             "manhattan"="manhattan", "canberra"="canberra", "binary"="binary", "pearson"="pearson",
             "abspearson"="abspearson", "correlation"="correlation", "abscorrelation"="abscorrelation",
             "spearman"="spearman", "kendall"="kendall"),selected = "squared.euclidean")
    ),

    mainPanel(
        tabsetPanel(

        tabPanel("Main",

            h3("Data"),
            p('Input values must be separated by tabs. Copy and paste from Excel/Numbers.'),
            p(HTML("<b><div style='background-color:#FADDF2;border:1px solid black;'>Please make sure that your data includes the header (variable names) in the first row.</div></b>")),

            strong('Option:'),
            checkboxInput("rowname", label = strong("The first column contains case names."), value = T),

            aceEditor("text", value="ID\tTOEIC\tOral.Rehearsal\tAssociate\tEx.Motiv\tIntr.Motiv\tTime\n1\t390\t2.7\t3.7\t3.33\t3.17\t6.92\n2\t360\t4.3\t3\t3.33\t3.17\t5.83\n3\t410\t2\t2\t2.67\t2.5\t2.36\n4\t390\t3.3\t2.7\t4.67\t4.83\t4.36\n5\t365\t3.7\t1\t3.67\t4.5\t3.78\n6\t415\t4.3\t2.7\t4.33\t3.5\t6.55\n7\t415\t3\t2.7\t4\t2.67\t4.56\n8\t340\t2.7\t1.7\t4.33\t2.83\t4\n9\t370\t3.3\t3\t4.33\t3.67\t4.73\n10\t360\t1.3\t1.7\t4.33\t2.5\t4.5\n11\t410\t3.3\t2.7\t4\t4.17\t8.3\n12\t430\t4\t2\t4\t4\t8.58\n13\t340\t3.3\t3.3\t3.67\t3.67\t4.9\n14\t305\t3.7\t2.3\t3.33\t3.83\t7\n15\t380\t1.7\t2.3\t4\t4\t6.92\n16\t390\t3.7\t1\t3.67\t3.33\t5.18\n17\t300\t2.7\t1.7\t3\t2.5\t3.73\n18\t370\t3\t3.7\t3.33\t1.83\t6.2\n19\t315\t2\t2\t2.67\t2.67\t3.22\n20\t370\t3.3\t2.3\t4\t4.17\t4\n21\t315\t2.7\t3.3\t3\t3.33\t2.75\n22\t385\t3\t2.7\t4\t2.83\t7.25\n23\t405\t4\t3.3\t4.33\t3.17\t2.56\n24\t380\t5\t1.7\t5\t4.17\t5.6\n25\t355\t1.3\t2.3\t4.33\t4.83\t6.36\n26\t310\t1\t2.3\t4.67\t2.83\t3.18\n27\t345\t5\t4.3\t3.67\t2.5\t5\n28\t390\t3.3\t4\t5\t5\t4.83\n29\t340\t1\t1.7\t4.67\t3.33\t5.75\n30\t365\t1.3\t2\t3.33\t3.17\t6.42",
                mode="r", theme="cobalt"),

            br(),

            h3("Basic statistics"),
            verbatimTextOutput("textarea.out"),

            br(),

            h3("Correlation"),

            radioButtons("method", "Choose the type of correlation coefficients:",
                        list("Pearson product-moment correlation coefficient" = "Pearson",
                             "Spearman's rank correlation coefficient (Spearman's rho)" = "Spearman",
                             "Kendall tau rank correlation coefficient (Kendall's tau)" = "Kendall")),

            verbatimTextOutput("correl.out"),

            br(),

            strong("Scatter plot matrices"),
            br(),

            plotOutput("corPlot"),

            br(),


            h3("Cluster analysis"),

            verbatimTextOutput("clusteranalysis.out"),

            plotOutput("clusterPlot"),

            h3("Specifying the number of clusters"),

            numericInput("numspec", "Number of clusters:", 3),

            br(),
            br(),

            plotOutput("specPlot"),

            strong("Basic statistics of each cluster (Applicable only for case clustering)"),
            verbatimTextOutput("specifiedCluster.out"),

            br(),
            strong("Profile plot (Applicable only for case clustering)"),
            br(),

            plotOutput("profilePlot", height = "600px", width="80%"),

            br(),
            br(),

            strong('R session info'),
            verbatimTextOutput("info.out")

            ),


        tabPanel("About",

            strong('Note'),
            p('This web application is developed with',
            a("Shiny.", href="http://www.rstudio.com/shiny/", target="_blank"),
            ''),

            br(),

            strong('List of Packages Used'), br(),
            code('library(shiny)'),br(),
            code('library(shinyAce)'),br(),
            code('library(psych)'),br(),
            code('library(amap)'),br(),

            br(),

            strong('Code'),
            p('Source code for this application is based on',
            a('"The handbook of Research in Foreign Language Learning and Teaching" (Takeuchi & Mizumoto, 2012).', href='http://mizumot.com/handbook/', target="_blank")),

            p('The code for this web application is available at',
            a('GitHub.', href='https://github.com/mizumot/cluster', target="_blank")),

            p('If you want to run this code on your computer (in a local R session), run the code below:',
            br(),
            code('library(shiny)'),br(),
            code('runGitHub("cluster","mizumot")')
            ),

            br(),

            strong('Citation in Publications'),
            p('Mizumoto, A. (2015). Langtest (Version 1.0) [Web application]. Retrieved from http://langtest.jp'),

            br(),

            strong('Article'),
            p('Mizumoto, A., & Plonsky, L. (2015).', a("R as a lingua franca: Advantages of using R for quantitative research in applied linguistics.", href='http://applij.oxfordjournals.org/content/early/2015/06/24/applin.amv025.abstract', target="_blank"), em('Applied Linguistics,'), 'Advance online publication. doi:10.1093/applin/amv025'),

            br(),

            strong('Recommended'),
            p('To learn more about R, I suggest this excellent and free e-book (pdf),',
            a("A Guide to Doing Statistics in Second Language Research Using R,", href="http://cw.routledge.com/textbooks/9780805861853/guide-to-R.asp", target="_blank"),
            'written by Dr. Jenifer Larson-Hall.'),

            p('Also, if you are a cool Mac user and want to use R with GUI,',
            a("MacR", href="https://sites.google.com/site/casualmacr/", target="_blank"),
            'is defenitely the way to go!'),

            br(),

            strong('Author'),
            p(a("Atsushi MIZUMOTO,", href="http://mizumot.com", target="_blank"),' Ph.D.',br(),
            'Associate Professor of Applied Linguistics',br(),
            'Faculty of Foreign Language Studies /',br(),
            'Graduate School of Foreign Language Education and Research,',br(),
            'Kansai University, Osaka, Japan'),

            br(),

            a(img(src="http://i.creativecommons.org/p/mark/1.0/80x15.png"), target="_blank", href="http://creativecommons.org/publicdomain/mark/1.0/"),

            p(br())

            )

))
))